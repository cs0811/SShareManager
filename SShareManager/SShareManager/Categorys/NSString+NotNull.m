//
//  NSString+NotNull.m
//  SShareManager
//
//  Created by tongxuan on 16/8/4.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "NSString+NotNull.h"

@implementation NSString (NotNull)

- (BOOL)notNull {
    if (!self) {
        return NO;
    }
    if (self.length==0 || [self isEqualToString:@" "] || [self isEqualToString:@""]) {
        return NO;
    }
    if ([self isEqualToString:@"<null>"] || [self isEqualToString:@"<NULL>"]) {
        return NO;
    }
    
    return YES;
}

@end
