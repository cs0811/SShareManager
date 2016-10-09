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
 NSString * const ShareChannel_QQ_TimeLine = @"ShareChannel_QQ_TimeLine";
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
            [channelArr addObject:ShareChannel_QQ_TimeLine];
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

+ (BOOL)isCanShareInWeiboAPP {
    return [SShareSinaHandle isCanShareInWeiboAPP];
}

+ (void)shareToChannel:(ShareChanel)chanel withMessage:(SShareMessage *)message completion:(SShareMCompletionBlock)block {
    if (chanel == QQ_Friend) {
        [SShareQQHandle shareMessage:message toType:ShareTo_Friend completion:^(SShareReusltCode reusltCode, NSString *errorInfo) {
            block((SShareMReusltCode)reusltCode,errorInfo);
        }];
    }else if (chanel == QQ_TimeLine) {
        [SShareQQHandle shareMessage:message toType:shareTo_TimeLine completion:^(SShareReusltCode reusltCode, NSString *errorInfo) {
            block((SShareMReusltCode)reusltCode,errorInfo);
        }];
    }else if (chanel == WX_Friend) {
        [SShareWXHandle shareMessage:message toType:ShareTo_Friend completion:^(SShareReusltCode reusltCode, NSString *errorInfo) {
            block((SShareMReusltCode)reusltCode,errorInfo);
        }];
    }else if (chanel == WX_TimeLine) {
        [SShareWXHandle shareMessage:message toType:shareTo_TimeLine completion:^(SShareReusltCode reusltCode, NSString *errorInfo) {
            block((SShareMReusltCode)reusltCode,errorInfo);
        }];
    }else if (chanel == Sina) {
        [SShareSinaHandle shareMessage:message toType:ShareTo_Friend completion:^(SShareReusltCode reusltCode, NSString *errorInfo) {
            block((SShareMReusltCode)reusltCode,errorInfo);
        }];
    }
}

+ (void)handleOpenUrl:(NSURL *)url completion:(SShareMCompletionBlock)block {
    // tencent100370679://response_from_qq?source=qq&source_scheme=mqqapi&error=0&version=1
    // wx9acfc1464c57b9b4://platformId=wechat
    // wb2726144177://response?id=BFA9DC72-51CD-40C4-942F-18758C683F7B&sdkversion=2.5
    
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"%@://platformId=wechat",kShare_WXKey]]) {
        // 微信
        [SShareWXHandle handleOpenUrl:url completion:^(SShareReusltCode reusltCode, NSString *errorInfo) {
            block((SShareMReusltCode)reusltCode,errorInfo);
        }];
    }else if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@://response_from_qq?source=qq&source_scheme=mqqapi",kShare_QQID]]) {
        // QQ
        [SShareQQHandle handleOpenUrl:url completion:^(SShareReusltCode reusltCode, NSString *errorInfo) {
            block((SShareMReusltCode)reusltCode,errorInfo);
        }];
    }else if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"wb%@://response",kShare_SinaKey]]) {
        // 新浪微博
        [SShareSinaHandle handleOpenUrl:url completion:^(SShareReusltCode reusltCode, NSString *errorInfo) {
            block((SShareMReusltCode)reusltCode,errorInfo);
        }];
    }
}

@end
