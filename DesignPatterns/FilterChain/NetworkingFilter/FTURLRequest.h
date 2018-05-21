//
//  FTURLRequest.h
//  DesignPatterns
//
//  Created by FinderTiwk on 18/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FTRequestMethod){
    /*! GET方式*/
    FTRequestMethod_GET       =  0,
    /*! POST方式*/
    FTRequestMethod_POST      =  1,
    /*! PUT方式*/
    FTRequestMethod_PUT       =  2,
    /*! DELETE方式*/
    FTRequestMethod_DELETE    =  3,
    /*! HEAD方式*/
    FTRequestMethod_HEAD      =  4,
    /*! OPTIONS方式*/
    FTRequestMethod_OPTIONS   =  5,
    /*! CONNECT方式*/
    FTRequestMethod_CONNECT   =  6,
    /*! TRACE方式*/
    FTRequestMethod_TRACE     =  7
};

@interface FTURLRequest : NSObject
//请求方式
@property (nonatomic,assign) FTRequestMethod requestMethod;
//请求域名
@property (nonatomic,copy) NSString *domain;
//请求接口
@property (nonatomic,copy) NSString *interface;

- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
//添加请求参数
- (void)addParams:(NSDictionary *)dict;
//添加单个请求的请求参数
- (void)addParam:(id)param forKey:(NSString *)key;

@property (nonatomic,readonly) NSData *bodyData;
@property (nonatomic,readonly) NSDictionary<NSString *,NSString *> *httpParams;
@property (nonatomic,readonly) NSDictionary<NSString *,NSString *> *httpHeadField;

- (void)removeAllParams;
- (void)removeAllHeaders;



@end
