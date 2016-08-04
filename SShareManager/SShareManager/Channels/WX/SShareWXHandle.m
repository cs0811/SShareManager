//
//  SShareWXHandle.m
//  SShareManager
//
//  Created by tongxuan on 16/8/3.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SShareWXHandle.h"

@implementation SShareWXHandle

+ (BOOL)canBeOpen {
    return YES;
}

// 没有网页版，需要判断是否安装微信
+ (BOOL)registerAPIs {
    
    return YES;
}

+ (void)shareMessage:(SShareMessage *)message toType:(ShareToType)type {
    if (type == ShareTo_Friend) {
        
    }else if (type == shareTo_TimeLine) {
        
    }
}

+ (void)handleOpenUrl:(NSURL *)url {
    
}

@end
