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

+ (void)shareMessage:(SShareMessage *)message toType:(ShareToType)type completion:(SShareCompletionBlock)block {
    
}

+ (void)handleOpenUrl:(NSURL *)url completion:(SShareCompletionBlock)block {
    
}
@end
