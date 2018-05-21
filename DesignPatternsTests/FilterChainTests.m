//
//  FilterChainTests.m
//  DesignPatternsTests
//
//  Created by FinderTiwk on 17/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HTMLFilter.h"
#import "SensitiveFilter.h"
#import "OtherFilter.h"
#import "StringFilterChain.h"


#import "NotFoundFilter.h"
#import "ParameterFilter.h"
#import "NetworkingSecretFilter.h"
#import "NetworkingSecretFilter.h"
#import "NetworkingFilterChain.h"

@interface FilterChainTests : XCTestCase

@property (nonatomic,strong) NetworkingFilterChain *networkingChain;
@property (nonatomic,strong) FTURLResponse *response;
@property (nonatomic,strong) FTURLRequest *request;

@end

@implementation FilterChainTests

- (void)setUp {
    [super setUp];
    self.networkingChain = [[NetworkingFilterChain alloc] init];
    self.networkingChain.addFilter([NotFoundFilter new]);
    self.networkingChain.addFilter([ParameterFilter new]);
    self.networkingChain.addFilter([NetworkingSecretFilter new]);
    
    self.request  = [[FTURLRequest alloc] init];
    self.request.requestMethod = FTRequestMethod_GET;
    self.request.domain = @"https://api.github.com";
    self.request.interface = @"/orgs/octokit/repos";
    [self.request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.request addParam:@"finderTiwk" forKey:@"usrename"];
    [self.request addParam:@(1514739661000) forKey:@"timestamp"];
    
    self.response = [[FTURLResponse alloc] init];
    self.response.statusCode = 200;
    self.response.allHeaderFields = @{@"sign":@"FinderTiwk",
                                      @"host":@"findertiwk.github.io",
                                      @"User-Agent":@"Mozilla /5.0"
                                      };
    self.response.retData = @{
                              @"code":@"0",
                              @"result":@{
                                      @"name":@"FinderTiwk",
                                      @"age":@"28",
                                      @"email":@"136652711@qq.com",
                                      }
                              };
}


- (void)testFilterChain{
    
    StringFilterChain *chain = [[StringFilterChain alloc] init];
//    id<StringFilter> filter1;
//    id<StringFilter> filter2;
//    id<StringFilter> filter3;
//
    {
        HTMLFilter *filter = [[HTMLFilter alloc] init];
        [filter addFilteRule:makeFilterRule(@"<", @"[")];
        [filter addFilteRule:makeFilterRule(@">", @"]")];
        [filter addFilteRule:makeFilterRule(@"&", @" and ")];
        [chain addFilter:filter];
//        filter1 = filter;
    }
    
    {
        SensitiveFilter *filter = [[SensitiveFilter alloc] init];
        [filter addFilteRule:makeFilterRule(@"共产党", @"伟大领袖")];
        [filter addFilteRule:makeFilterRule(@"敏感", @"不敏感")];
        [filter addFilteRule:makeFilterRule(@"中国男足", @"男猪")];
        [chain addFilter:filter];
//        filter2 = filter;
    }
    
    {
        OtherFilter *filter = [[OtherFilter alloc] init];
        [chain addFilter:filter];
//        filter3 = filter;
    }
    
//    chain.addFilter(filter1).addFilter(filter2).addFilter(filter3);
    NSString *result = [chain doFilterFor:@"<真是太敏感了> & 共产党万岁, other ..中国男足"];
    NSString *expected = @"[真是太不敏感了]  and  伟大领袖万岁, 其它的过滤器 ..男猪";
    XCTAssertTrue([result isEqualToString:expected]);
    
}




- (void)testNotFoundFilterA{
    self.request.interface = @"/api/regist";
    NSError *error;
    [self.networkingChain doFilterForRequest:self.request
                                    response:self.response
                                       chain:self.networkingChain
                                       error:&error];
    XCTAssertNotNil(error);
    XCTAssert([error.localizedDescription isEqualToString:@"404 Not Found!"]);
}


- (void)testParamerFilterA{
    self.request.domain = @"";
    NSError *error;
    [self.networkingChain doFilterForRequest:self.request
                                    response:self.response
                                       chain:self.networkingChain
                                       error:&error];
    XCTAssertNotNil(error);
    XCTAssert([error.localizedDescription isEqualToString:@"请求域名为空"]);
    
    error = nil;
    self.request.domain = @"https://api.github.com";
    self.request.interface = @"";
    [self.networkingChain doFilterForRequest:self.request
                                    response:self.response
                                       chain:self.networkingChain
                                       error:&error];
    XCTAssertNotNil(error);
    XCTAssert([error.localizedDescription isEqualToString:@"请求API为空"]);
    
    error = nil;
    self.request.interface = @"/orgs/octokit/repos";
    [self.request removeAllHeaders];
    [self.networkingChain doFilterForRequest:self.request
                                    response:self.response
                                       chain:self.networkingChain
                                       error:&error];
    XCTAssertNotNil(error);
    XCTAssert([error.localizedDescription isEqualToString:@"请求头为空"]);
    
    error = nil;
    [self.request addValue:@"application/json"
        forHTTPHeaderField:@"Content-Type"];
    [self.networkingChain doFilterForRequest:self.request
                                    response:self.response
                                       chain:self.networkingChain
                                       error:&error];
    XCTAssertNil(error);
    
    
}

- (void)testSecretFilterA{
    NSError *error;
    [self.networkingChain doFilterForRequest:self.request
                                    response:self.response
                                       chain:self.networkingChain
                                       error:&error];
    
    XCTAssertNil(error);
    XCTAssertNotNil(self.request.httpHeadField[@"sign"]);
    XCTAssert([self.request.httpHeadField[@"sign"] isEqualToString:@"FinderTiwk"]);
    
    XCTAssertNotNil(self.request.httpHeadField[@"host"]);
    XCTAssert([self.request.httpHeadField[@"host"] isEqualToString:@"findertiwk.github.io"]);
}


- (void)testSecretFilterB{
    NSError *error;
    [self.response removeAllHeaders];
    [self.networkingChain doFilterForRequest:self.request
                                    response:self.response
                                       chain:self.networkingChain
                                       error:&error];
    
    XCTAssertNotNil(error);
    XCTAssert([error.localizedDescription isEqualToString:@"无效的响应头"]);
    
    
    
    error = nil;
    self.response.allHeaderFields = @{@"sign":@"hack",
                                      @"host":@"findertiwk.github.io"};
    
    [self.networkingChain doFilterForRequest:self.request
                                    response:self.response
                                       chain:self.networkingChain
                                       error:&error];
    XCTAssertNotNil(error);
    XCTAssert([error.localizedDescription isEqualToString:@"响应数据加密签名验证失败"]);
    
    
    error = nil;
    self.response.allHeaderFields = @{@"sign":@"FinderTiwk",
                                      @"host":@"findertiwk.github.io",
                                      @"User-Agent":@"Mozilla /5.0"
                                      };
    [self.networkingChain doFilterForRequest:self.request
                                    response:self.response
                                       chain:self.networkingChain
                                       error:&error];
    XCTAssertNil(error);
    
}


- (void)testParamerFilterB{
    
    NSError *error;
    self.response.statusCode = -1001;
    [self.networkingChain doFilterForRequest:self.request
                                    response:self.response
                                       chain:self.networkingChain
                                       error:&error];
    XCTAssertNotNil(error);
    XCTAssert([error.localizedDescription hasPrefix:@"网络异常,请重试"]);
    
    error = nil;
    self.response.statusCode = 200;
    self.response.allHeaderFields = @{@"sign":@"FinderTiwk",
                                      @"host":@"findertiwk.github.io"};
    [self.response removeAllRetData];
    [self.networkingChain doFilterForRequest:self.request
                                    response:self.response
                                       chain:self.networkingChain
                                       error:&error];
    XCTAssertNotNil(error);
    XCTAssert([error.localizedDescription isEqualToString:@"返回数据为空"]);
    
    error = nil;
    self.response.retData = @{
                              @"code":@"0",
                              @"result":@{
                                      @"name":@"FinderTiwk",
                                      @"age":@"28",
                                      @"email":@"136652711@qq.com",
                                      }
                              };
    [self.networkingChain doFilterForRequest:self.request
                                    response:self.response
                                       chain:self.networkingChain
                                       error:&error];
    XCTAssertNil(error);
    
}


@end
