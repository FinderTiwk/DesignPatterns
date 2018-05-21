//
//  StringFilterChain.h
//  DesignPatterns
//
//  Created by FinderTiwk on 17/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringFilter.h"

@interface StringFilterChain : NSObject

- (void)addFilter:(id<StringFilter>)filter;

- (StringFilterChain* (^)(id<StringFilter> filter))addFilter;

- (NSString *)doFilterFor:(NSString *)aString;

@end
