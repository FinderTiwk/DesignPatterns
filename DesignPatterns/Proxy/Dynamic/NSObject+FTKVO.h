//
//  NSObject+FTKVO.h
//  Chapter1: [Runtime]
//
//  Created by FinderTiwk on 02/04/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 KVO实现原理:
    1. 判断被监听的对象的keyPath是否有对应的set方法,没有直接报错
    2. 判断是否已经生成监听对象类的子类,如果没有生成进行下一步,如果有生成,跳过
    3. 生成监听对象类的子类,重写class方法来掩盖真实的类,为子类添加对应的set方法,向系统注册此类
    4. 交换子类与父类的isa指针
    5. 保存上下文等
 */


typedef void(^FTKVOBlock)(id observer, NSString *keyPath, id oldValue, id newValue);;

@interface NSObject (FTKVO)


//是否开启线程安全,默认不是线程安全的
+ (void)threadSaftyEnable:(BOOL)enable;

- (void)ft_addObserver:(NSObject *)observer
            forKeyPath:(NSString *)keyPath
              callback:(FTKVOBlock)callback;


- (void)ft_removeObserver:(NSObject *)observer
               forKeyPath:(NSString *)keyPath;

- (void)ft_removeAllObservers;

@end
