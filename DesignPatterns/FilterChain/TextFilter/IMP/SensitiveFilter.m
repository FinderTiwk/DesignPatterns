//
//  SensitiveFilter.m
//  DesignPatterns
//
//  Created by FinderTiwk on 17/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "SensitiveFilter.h"

@implementation SensitiveFilter

@synthesize filteRules;

- (instancetype)init{
    if (self = [super init]) {
        filteRules = [NSMutableArray array];
    }
    return self;
}

- (void)addFilteRule:(NSDictionary *)rule{
    [self.filteRules addObject:rule];
}

- (NSString *)filterString:(NSString *)aString{
    for (NSDictionary *rule in self.filteRules) {
        NSString *old = rule[kHTMLTag_OLD];
        NSString *replaced = rule[kHTMLTag_NEW];
        aString = [aString stringByReplacingOccurrencesOfString:old withString:replaced];
    }
    return aString;
}



@end
