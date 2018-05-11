//
//  SingletonObj.h
//  DesignPatterns
//
//  Created by FinderTiwk on 11/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonObj1 : NSObject

//将alloc init 方法禁用
//- (instancetype)init __attribute__((unavailable("只能使用 + shareInstance方法")));
//+ (instancetype)new __attribute__((unavailable("只能使用 + shareInstance方法")));

+ (instancetype)shareInstance;

@end


@interface SingletonObj2 : NSObject

//将alloc init 方法禁用
//- (instancetype)init __attribute__((unavailable("只能使用 + shareInstance方法")));
//+ (instancetype)new __attribute__((unavailable("只能使用 + shareInstance方法")));

//+ (instancetype)instance;

@property (nonatomic,readonly,class) SingletonObj2 *instance;

@end
