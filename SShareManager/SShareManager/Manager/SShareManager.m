//
//  SShareManager.m
//  SShareManager
//
//  Created by tongxuan on 16/6/24.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SShareManager.h"
#import "SShareWXHandle.h"
#import "SShareSinaHandle.h"
#import "SShareQQHandle.h"

 NSString * const ShareChannel_QQ_Friend = @"ShareChannel_QQ_Friend";
 NSString * const ShareChannel_WX_Friend = @"ShareChannel_WX_Friend";          // 微信好友
 NSString * const ShareChannel_WX_TimeLine = @"ShareChannel_WX_TimeLine";      // 微信朋友圈
 NSString * const ShareChannel_Sina = @"ShareChannel_Sina";


@implementation SShareManager

+ (NSArray *)registerAPIs {
    NSMutableArray * channelArr = [NSMutableArray array];
    if ([SShareQQHandle canBeOpen]) {
        // 没有网页版，需要判断是否安装QQ
        if ([SShareQQHandle registerAPIs]) {
            [channelArr addObject:ShareChannel_QQ_Friend];
        }
    }
    if ([SShareWXHandle canBeOpen]) {
        // 没有网页版，需要判断是否安装微信
        if ([SShareWXHandle registerAPIs]) {
            [channelArr addObject:ShareChannel_WX_Friend];
            [channelArr addObject:ShareChannel_WX_TimeLine];
        }
    }
    if ([SShareSinaHandle canBeOpen]) {
        if ([SShareSinaHandle registerAPIs]) {
            [channelArr addObject:ShareChannel_Sina];
        }
    }
    return channelArr;
}


+ (void)shareToChannel:(ShareChanel)chanel withMessage:(SShareMessage *)message {
    if (chanel == QQ_Friend) {
        [SShareQQHandle shareMessage:message toType:ShareTo_Friend];
    }else if (chanel == WX_Friend) {
        [SShareWXHandle shareMessage:message toType:ShareTo_Friend];
    }else if (chanel == WX_TimeLine) {
        [SShareWXHandle shareMessage:message toType:shareTo_TimeLine];
    }else if (chanel == Sina) {
        [SShareSinaHandle shareMessage:message toType:ShareTo_Friend];
    }
}

+ (void)handleOpenUrl:(NSURL *)url {
    [SShareQQHandle handleOpenUrl:url];
    [SShareWXHandle handleOpenUrl:url];
    [SShareSinaHandle handleOpenUrl:url];
}

@end
