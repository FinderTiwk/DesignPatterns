//
//  OtherFilter.m
//  DesignPatterns
//
//  Created by FinderTiwk on 17/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "OtherFilter.h"

@implementation OtherFilter

- (NSString *)filterString:(NSString *)aString{
    
    aString = [aString stringByReplacingOccurrencesOfString:@"other"
                                                 withString:@"其它的过滤器"];
    return aString;
}

@end
