//
//  FTURLResponse.m
//  DesignPatterns
//
//  Created by FinderTiwk on 18/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "FTURLResponse.h"

@implementation FTURLResponse


- (void)removeAllHeaders{
    self.allHeaderFields = @{};
}
- (void)removeAllRetData{
    self.retData = @{};
}

@end
