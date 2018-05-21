//
//  FTURLRequest.m
//  DesignPatterns
//
//  Created by FinderTiwk on 18/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "FTURLRequest.h"

static NSString *FTRequestMethodStrings[] = {
    [FTRequestMethod_GET]     = @"GET",
    [FTRequestMethod_POST]    = @"POST",
    [FTRequestMethod_PUT]     = @"PUT",
    [FTRequestMethod_DELETE]  = @"DELETE",
    [FTRequestMethod_HEAD]    = @"HEAD",
    [FTRequestMethod_OPTIONS] = @"OPTIONS",
    [FTRequestMethod_CONNECT] = @"CONNECT",
    [FTRequestMethod_TRACE]   = @"TRACE"
};


@interface FTURLRequest()
//请求头
@property (nonatomic,strong) NSMutableDictionary *headFileds;
//请求参数
@property (nonatomic,strong) NSMutableDictionary<NSString *,NSString *> *params;
@end

@implementation FTURLRequest

- (instancetype)init{
    if (self = [super init]) {
        self.headFileds = [NSMutableDictionary dictionary];
        self.params = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSMutableDictionary<NSString *,NSString *> *)httpParams{
    return [self.params copy];
}
- (void)removeAllParams{
    [self.params removeAllObjects];
}

- (NSDictionary<NSString *,NSString *> *)httpHeadField{
    return [self.headFileds copy];
}
- (void)removeAllHeaders{
    [self.headFileds removeAllObjects];
}

- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field{
    NSParameterAssert(field);
    NSParameterAssert(value);
    self.headFileds[field] = value;
}

- (void)addParams:(NSDictionary *)dict{
    NSParameterAssert(dict);
    [self.params addEntriesFromDictionary:dict];
}

- (void)addParam:(id)param forKey:(NSString *)key{
    NSParameterAssert(key);
    NSParameterAssert(param);
    self.params[key] = param;
}

@end
