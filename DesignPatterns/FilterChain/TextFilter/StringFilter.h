//
//  Filterable.h
//  DesignPatterns
//
//  Created by FinderTiwk on 17/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const kHTMLTag_OLD;
FOUNDATION_EXTERN NSString *const kHTMLTag_NEW;

NS_INLINE NSDictionary* makeFilterRule(NSString *htmlTag, NSString *aString){
    return @{kHTMLTag_OLD:htmlTag,
             kHTMLTag_NEW:aString
             };
}

@protocol StringFilter <NSObject>

@required
- (NSString *)filterString:(NSString *)aString;

@optional
@property (nonatomic,strong) NSMutableArray<NSDictionary *> *filteRules;
/*
 添加过滤规则 eg: {kHTMLTag_OLD: @"<" ,kHTMLTag_NEW: @"["}
 将字符串中的html标签替换为其它字符串
 */
@optional
- (void)addFilteRule:(NSDictionary *)rule;

@end


