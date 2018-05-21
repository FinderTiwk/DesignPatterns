//
//  NetworkingFilterChain.h
//  DesignPatterns
//
//  Created by FinderTiwk on 18/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingFilter.h"

@interface NetworkingFilterChain : NSObject<NetworkingFilter>

- (NetworkingFilterChain* (^)(id<NetworkingFilter> filter))addFilter;

@end
