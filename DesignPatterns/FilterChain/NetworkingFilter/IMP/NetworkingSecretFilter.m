//
//  NetworkingSecretFilter.m
//  DesignPatterns
//
//  Created by FinderTiwk on 18/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "NetworkingSecretFilter.h"
#import "NetworkingFilterChain.h"

@implementation NetworkingSecretFilter

- (void)doFilterForRequest:(FTURLRequest *)request
                  response:(FTURLResponse *)response
                     chain:(NetworkingFilterChain *)chain
                     error:(NSError *__autoreleasing *)error{
    
    [self encryptionFor:&request];
    
    [chain doFilterForRequest:request
                     response:response
                        chain:chain
                        error:error];
    
    if (*error) {
        return;
    }
    
    [self decryptionFor:response
                  error:error];
}


//做加密处理
- (void)encryptionFor:(FTURLRequest **)aRequest{
    
    [(*aRequest) addValue:@"FinderTiwk" forHTTPHeaderField:@"sign"];
    [(*aRequest) addValue:@"findertiwk.github.io" forHTTPHeaderField:@"host"];
}


//做验签处理
- (void)decryptionFor:(FTURLResponse *)aResponse
                error:(NSError **)error{
    
    NSArray *allHeadKeys = aResponse.allHeaderFields.allKeys;
    if (![allHeadKeys containsObject:@"host"] ||
        ![allHeadKeys containsObject:@"sign"]) {
        *error = makeFilterError(-1, @"无效的响应头");
        return;
    }
    
    if (![aResponse.allHeaderFields[@"sign"] isEqualToString:@"FinderTiwk"]) {
        *error = makeFilterError(-1, @"响应数据加密签名验证失败");
        return;
    }

}

@end
