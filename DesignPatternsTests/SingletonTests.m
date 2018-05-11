//
//  SingletonTests.m
//  DesignPatternsTests
//
//  Created by FinderTiwk on 11/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SingletonObj.h"

@interface SingletonTests : XCTestCase

@end

@implementation SingletonTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit1{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        SingletonObj1 *obj1 = [SingletonObj1 shareInstance];
        SingletonObj1 *obj2 = [[SingletonObj1 alloc] init];
        SingletonObj1 *obj3 = [SingletonObj1 new];
        NSLog(@"global adress1 = %p",obj1);
        NSLog(@"global adress2 = %p",obj2);
        NSLog(@"global adress3 = %p",obj3);
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        SingletonObj1 *obj1 = [SingletonObj1 shareInstance];
        SingletonObj1 *obj2 = [[SingletonObj1 alloc] init];
        SingletonObj1 *obj3 = [SingletonObj1 new];
        NSLog(@"global adress4 = %p",obj1);
        NSLog(@"global adress5 = %p",obj2);
        NSLog(@"global adress6 = %p",obj3);
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SingletonObj1 *obj1 = [SingletonObj1 shareInstance];
        SingletonObj1 *obj2 = [[SingletonObj1 alloc] init];
        SingletonObj1 *obj3 = [SingletonObj1 new];
        NSLog(@"main adress1 = %p",obj1);
        NSLog(@"main adress2 = %p",obj2);
        NSLog(@"main adress3 = %p",obj3);
    });
}

- (void)testInit2{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        SingletonObj2 *obj1 = [SingletonObj2 instance];
        SingletonObj2 *obj2 = [[SingletonObj2 alloc] init];
        SingletonObj2 *obj3 = [SingletonObj2 new];
        NSLog(@"global adress1 = %p",obj1);
        NSLog(@"global adress2 = %p",obj2);
        NSLog(@"global adress3 = %p",obj3);
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        SingletonObj2 *obj1 = [SingletonObj2 instance];
        SingletonObj2 *obj2 = [[SingletonObj2 alloc] init];
        SingletonObj2 *obj3 = [SingletonObj2 new];
        NSLog(@"global adress4 = %p",obj1);
        NSLog(@"global adress5 = %p",obj2);
        NSLog(@"global adress6 = %p",obj3);
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SingletonObj2 *obj1 = [SingletonObj2 instance];
        SingletonObj2 *obj2 = [[SingletonObj2 alloc] init];
        SingletonObj2 *obj3 = [SingletonObj2 new];
        NSLog(@"main adress1 = %p",obj1);
        NSLog(@"main adress2 = %p",obj2);
        NSLog(@"main adress3 = %p",obj3);
    });
}

@end
