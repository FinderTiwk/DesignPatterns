//
//  FTURLResponse.h
//  DesignPatterns
//
//  Created by FinderTiwk on 18/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTURLResponse : NSObject

@property (nonatomic,assign) NSInteger statusCode;
@property (nonatomic,strong) NSDictionary *allHeaderFields;
@property (nonatomic,strong) NSDictionary *retData;

- (void)removeAllHeaders;
- (void)removeAllRetData;

@end
