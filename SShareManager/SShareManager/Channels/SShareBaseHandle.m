//
//  SShareBaseHandle.m
//  SShareManager
//
//  Created by tongxuan on 16/8/3.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SShareBaseHandle.h"

@implementation SShareBaseHandle

+ (BOOL)canBeOpen {
    return NO;
}

+ (BOOL)registerAPIs {
    return NO;
}

+ (void)shareMessage:(SShareMessage *)message toType:(ShareToType)type {
    
}

+ (void)handleOpenUrl:(NSURL *)url {
    
}
@end
