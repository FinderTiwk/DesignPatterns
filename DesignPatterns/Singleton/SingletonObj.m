//
//  SingletonObj.m
//  DesignPatterns
//
//  Created by FinderTiwk on 11/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "SingletonObj.h"

@implementation SingletonObj1
static SingletonObj1 *__instance1 = nil;
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(__builtin_expect(!__instance1,NO)) {
            __instance1 = [[self alloc] init];
        }
    });
    return __instance1;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(__builtin_expect(!__instance1,NO)) {
            __instance1 = [[super allocWithZone:zone] init];
        }
    });
    
    return __instance1;
}
@end



@interface SingletonObj2()
@end


@implementation SingletonObj2

static SingletonObj2 *__instance2 = nil;
+ (instancetype)instance{
    if(__builtin_expect(!__instance2,NO)){
        __instance2 = [[SingletonObj2 alloc] init];
    }
    return __instance2;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(__builtin_expect(!__instance2,NO)) {
            __instance2 = [[super allocWithZone:zone] init];
        }
    });
    return __instance2;
}


@end


