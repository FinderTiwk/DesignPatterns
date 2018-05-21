//
//  NotFoundSecretFilter.m
//  DesignPatterns
//
//  Created by FinderTiwk on 21/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "NotFoundFilter.h"
#import "NetworkingFilterChain.h"

@interface NotFoundFilter()
@property (nonatomic,strong) NSArray *blackList;
@end

@implementation NotFoundFilter

- (NSArray *)blackList{
    if (!_blackList) {
        _blackList = @[@"/api/regist",@"/api/buy"];
    }
    return _blackList;
}

- (void)doFilterForRequest:(FTURLRequest *)request
                  response:(FTURLResponse *)response
                     chain:(NetworkingFilterChain *)chain
                     error:(NSError **)error{
    
    [self checkRequest:request
                 error:error];
    
    [chain doFilterForRequest:request
                     response:response
                        chain:chain
                        error:error];
    
}

- (void)checkRequest:(FTURLRequest *)aRequest
               error:(NSError **)error{
    if ([self.blackList containsObject:aRequest.interface]) {
        *error = makeFilterError(-1, @"404 Not Found!");
    }
}

@end
