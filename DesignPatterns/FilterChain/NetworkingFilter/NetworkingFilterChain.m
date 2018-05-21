//
//  NetworkingFilterChain.m
//  DesignPatterns
//
//  Created by FinderTiwk on 18/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "NetworkingFilterChain.h"

@interface NetworkingFilterChain()
@property (nonatomic,strong) NSMutableArray<id<NetworkingFilter>> *filters;
@property (nonatomic,assign) NSUInteger index;
@end

@implementation NetworkingFilterChain


- (instancetype)init{
    if (self = [super init]) {
        _filters = [NSMutableArray array];
    }
    return self;
}

- (NetworkingFilterChain *(^)(id<NetworkingFilter>))addFilter{
    return ^(id<NetworkingFilter> filter){
        [self.filters addObject:filter];
        return self;
    };
}


#pragma mark - NetworkingFilter
- (void)doFilterForRequest:(FTURLRequest *)request
                  response:(FTURLResponse *)response
                     chain:(NetworkingFilterChain *)chain
                     error:(NSError *__autoreleasing *)error{
    if (*error) {
        self.index = 0;
        return;
    }
    if (self.index == self.filters.count) {
        self.index = 0;
        return;
    }
    id<NetworkingFilter> filter = self.filters[self.index++];
    [filter doFilterForRequest:request
                      response:response
                         chain:self
                         error:error];
    
}

@end
