//
//  NetworkingFilter.h
//  DesignPatterns
//
//  Created by FinderTiwk on 18/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTURLRequest.h"
#import "FTURLResponse.h"

NS_INLINE NSError* makeFilterError(NSUInteger errorCode, NSString *desc){
    return [NSError errorWithDomain:@"com.finderTiwk"
                               code:errorCode
                           userInfo:@{NSLocalizedDescriptionKey:desc}];
}

@class NetworkingFilterChain;
@protocol NetworkingFilter <NSObject>

- (void)doFilterForRequest:(FTURLRequest *)request
                  response:(FTURLResponse *)response
                     chain:(NetworkingFilterChain *)chain
                     error:(NSError **)error;
@end
