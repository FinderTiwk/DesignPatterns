//
//  NSObject+FTKVO.m
//  Chapter1: [Runtime]
//
//  Created by FinderTiwk on 02/04/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "NSObject+FTKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <pthread/pthread.h>

NSString *const FTKVOClassPrefix = @"FTKVONotifying_";
static const char* FTKVOObserversAssociatedKey = "FTKVOObserversAssociatedKey";

@interface FTKVOItem: NSObject
@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) void(^callback)(id observer, NSString *keyPath, id oldValue, id newValue);
@end

@implementation FTKVOItem

- (BOOL)isEqual:(id)object{
    FTKVOItem *item = (FTKVOItem *)object;
    if (item.observer != self.observer) {
        return NO;
    }
    return [item.keyPath isEqualToString:self.keyPath];
}

- (NSUInteger)hash{
    return ([self.observer hash] ^ [self.keyPath hash]);
}

@end

@implementation NSObject (FTKVO)

static BOOL __kvoThreadSafty = NO;
static pthread_mutex_t __kvoLock;
+ (void)threadSaftyEnable:(BOOL)enable{
    __kvoThreadSafty = enable;
    if (enable) {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&__kvoLock, &attr);
        pthread_mutexattr_destroy(&attr);
    }
}



- (void)ft_addObserver:(NSObject *)observer
            forKeyPath:(NSString *)keyPath
              callback:(FTKVOBlock)callback{
    NSCParameterAssert(observer);
    NSCParameterAssert(keyPath);
    
    if (__kvoThreadSafty) {
        pthread_mutex_lock(&__kvoLock);
    }
    
    //1. 判断被监听的对象有没有keypath对应的set方法
    SEL setterSEL = NSSelectorFromString([NSString stringWithFormat:@"set%@:",[keyPath capitalizedString]]);
    
    Class clazz = object_getClass(self);
    
    Method setterMethod = class_getInstanceMethod(clazz, setterSEL);
    if (!setterMethod) {
        NSAssert(NO, @"此类没有对应的keyPath");
        return;
    }
    
    //2. 判断当前有没有注册的监听类,如果没有,则注册一个
    NSString *clazzName = NSStringFromClass(clazz);
    if (![clazzName hasPrefix:FTKVOClassPrefix]) {
        NSString *kvoClazzName = [FTKVOClassPrefix stringByAppendingString:clazzName];
        Class kvoClazz = NSClassFromString(kvoClazzName);
        
        kvoClazz = objc_allocateClassPair(clazz, [kvoClazzName UTF8String], 0);
        
        //2.0 重写class方法, 返回原始类来进行掩盖
        Class superClazz = class_getSuperclass(kvoClazz);
        Method instanceClazzMethod = class_getInstanceMethod(superClazz, @selector(class));
        IMP classIMP = class_getMethodImplementation([self class], @selector(class));
        class_addMethod(kvoClazz, @selector(class), classIMP, method_getTypeEncoding(instanceClazzMethod));
        
        //2.1 为生成的子类添加setter方法
        class_addMethod(kvoClazz, setterSEL, (IMP)kvo_setter_impl, method_getTypeEncoding(setterMethod));
        
        //2.2 向系统注册KVO类
        objc_registerClassPair(kvoClazz);
        
        //2.2 将生成的KVO监听类的子类isa指向原来的类
        object_setClass(self,kvoClazz);
    }
    
    
    //3. 添加一个集合来维护监听者
    NSMutableSet<FTKVOItem *> *observers = objc_getAssociatedObject(self, &FTKVOObserversAssociatedKey);
    if (!observers) {
        observers = [[NSMutableSet alloc] initWithCapacity:3];
        objc_setAssociatedObject(self, &FTKVOObserversAssociatedKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    FTKVOItem *item = [FTKVOItem new];
    item.observer = observer;
    item.keyPath  = keyPath;
    item.callback = callback;
    //NSSet添加对象时第一次没有元素时不会调用 isEqual方法
    //后面添加元素时会先调用hash,然后 isEqual
    [observers addObject:item];
    
    if (__kvoThreadSafty) {
        pthread_mutex_unlock(&__kvoLock);
    }
}

- (void)ft_removeObserver:(NSObject *)observer
               forKeyPath:(NSString *)keyPath{
    if (__kvoThreadSafty) {
        pthread_mutex_lock(&__kvoLock);
    }
    NSMutableSet<FTKVOItem *> *observers = objc_getAssociatedObject(self, &FTKVOObserversAssociatedKey);
    if (observers) {
        NSEnumerator *enumerator = observers.objectEnumerator;
        FTKVOItem *item;
        while (item = [enumerator nextObject]) {
            if ((item.observer == observers) &&
                [item.keyPath isEqualToString:keyPath]) {
                [observers removeObject:item];
                break;
            }
        }
    }
    if (__kvoThreadSafty) {
        pthread_mutex_unlock(&__kvoLock);
    }
}

- (void)ft_removeAllObservers{
    if (__kvoThreadSafty) {
        pthread_mutex_lock(&__kvoLock);
    }
    NSMutableSet<FTKVOItem *> *observers = objc_getAssociatedObject(self, &FTKVOObserversAssociatedKey);
    [observers removeAllObjects];
    if (__kvoThreadSafty) {
        pthread_mutex_unlock(&__kvoLock);
    }
}

#pragma mark - 工具方法

//implementation of KVO setter method
static void kvo_setter_impl(id self, SEL _cmd, id newValue){
    if (__kvoThreadSafty) {
        pthread_mutex_lock(&__kvoLock);
    }
    
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *keyPath = keyPathBy(setterName);
    Class superClazz = class_getSuperclass([self class]);
    
    struct objc_super superStrt = {
        .receiver = self,           //insatance of this class
        .super_class = superClazz,  //super class
    };
    
    //定义一个指向objc_msgSendSuper()函数的函数指针
    void (*msgSendToSuperFunc)(void *,SEL,id) = (void *)objc_msgSendSuper;
    NSMutableSet<FTKVOItem *> *observers = objc_getAssociatedObject(self, &FTKVOObserversAssociatedKey);
    
    NSEnumerator *enumerator = observers.objectEnumerator;
    FTKVOItem *item;
    while (item = [enumerator nextObject]) {
        if (!item.observer) {
            [observers removeObject:item];
            break;
        }else{
            [item.observer willChangeValueForKey:keyPath];
        }
    }
    
    //调用objc_msgSendSuper()方法
    msgSendToSuperFunc(&superStrt,_cmd,newValue);
    
    id oldValue = [self valueForKey:keyPath]?:@"";
    
    for (FTKVOItem *item in observers) {
        //KVO 在调用存取方法之后调用
        if (item.callback) {
            item.callback(item.observer, keyPath, oldValue, newValue);
        }else{
            NSDictionary<NSKeyValueChangeKey, id> *changeInfo = @{NSKeyValueChangeOldKey:oldValue,NSKeyValueChangeNewKey:newValue};
            [item.observer observeValueForKeyPath:keyPath
                                         ofObject:self
                                           change:changeInfo
                                          context:nil];
        }
        [item.observer didChangeValueForKey:keyPath];
    }
    if (__kvoThreadSafty) {
        pthread_mutex_unlock(&__kvoLock);
    }
}

static NSString *keyPathBy(NSString *setterName){
    NSCParameterAssert(setterName);
    NSRange range = NSMakeRange(3, setterName.length - 4);
    NSString *getterName = [setterName substringWithRange:range];
    
    NSRange replaceRange =NSMakeRange(0, 1);
    NSString *firstLetter = [[getterName substringWithRange:replaceRange] lowercaseString];
    
    getterName = [getterName stringByReplacingCharactersInRange:replaceRange
                                                     withString:firstLetter];
    return getterName;
}

@end
