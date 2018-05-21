//
//  FilterChain.m
//  DesignPatterns
//
//  Created by FinderTiwk on 17/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "StringFilterChain.h"
#import <UIKit/UIKit.h>

NSString *const kHTMLTag_OLD = @"kHTMLTag_OLD";
NSString *const kHTMLTag_NEW = @"kHTMLTag_NEW";

@interface StringFilterChain()
@property (nonatomic,strong) NSMutableArray<id<StringFilter>> *filters;
@end

@implementation StringFilterChain

- (instancetype)init{
    if (self = [super init]) {
        _filters = [NSMutableArray array];
    }   
    return self;
}



- (void)addFilter:(id<StringFilter>)filter{
    [self.filters addObject:filter];
}

- (StringFilterChain* (^)(id<StringFilter> filter))addFilter{
    return ^(id<StringFilter> filter){
        [self.filters addObject:filter];
        return self;
    };
}


- (NSString *)doFilterFor:(NSString *)aString{
    for (id<StringFilter> filter in self.filters) {
        aString = [filter filterString:aString];
    }
    return aString;
}

@end
