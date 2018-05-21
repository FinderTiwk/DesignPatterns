//
//  ParameterFilter.m
//  DesignPatterns
//
//  Created by FinderTiwk on 18/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "ParameterFilter.h"
#import "NetworkingFilterChain.h"

@implementation ParameterFilter

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
    if (*error) {
        return;
    }
    
    [self checkResponse:response
                  error:error];
}



- (void)checkRequest:(FTURLRequest *)aRequest
               error:(NSError **)error{
    
    if (!aRequest.domain ||
        aRequest.domain.length == 0) {
        *error = makeFilterError(-1, @"请求域名为空");
        return;
    }
    
    if (!aRequest.interface ||
        aRequest.interface.length == 0) {
        *error = makeFilterError(-1, @"请求API为空");
        return;
    }
    
    if (!aRequest.httpHeadField ||
        aRequest.httpHeadField.allKeys.count == 0) {
        *error = makeFilterError(-1, @"请求头为空");
        return;
    }
}

- (void)checkResponse:(FTURLResponse *)aResponse
               error:(NSError **)error{
    
    NSInteger responseCode = aResponse.statusCode;
    if (responseCode != 200) {
        
        NSString *desc = [NSString stringWithFormat:@"网络异常,请重试(%@)",@(responseCode)];
        *error = makeFilterError(aResponse.statusCode, desc);
        return;
    }
    
    if (!aResponse.retData ||
        aResponse.retData.allKeys.count == 0) {
        *error = makeFilterError(-1, @"返回数据为空");
        return;
    }

}

@end
