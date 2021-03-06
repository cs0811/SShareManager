//
//  SShareManager.h
//  SShareManager
//
//  Created by tongxuan on 16/6/24.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const ShareChannel_QQ_Friend;
UIKIT_EXTERN NSString * const ShareChannel_QQ_TimeLine;
UIKIT_EXTERN NSString * const ShareChannel_WX_Friend;           // 微信好友
UIKIT_EXTERN NSString * const ShareChannel_WX_TimeLine;         // 微信朋友圈
UIKIT_EXTERN NSString * const ShareChannel_Sina;

typedef NS_ENUM(NSInteger, ShareChanel) {
    QQ_Friend = 0,
    QQ_TimeLine ,
    WX_Friend ,
    WX_TimeLine ,
    Sina ,
};

typedef NS_ENUM(NSInteger,SShareMReusltCode) {
    SShareMReuslt_Unknown    = 0,        // 未知
    SShareMReuslt_Success ,              // 成功
    SShareMReuslt_UserCancel ,           // 用户取消
    SShareMReuslt_Failed     ,           // 失败
};

@class SShareMessage;

typedef void(^SShareMCompletionBlock)(SShareMReusltCode reusltCode, NSString * errorInfo);

@interface SShareManager : NSObject

/**
 *  注册各个分享渠道
 *
 *  @return 返回可用的分享渠道
 */
+ (NSArray *)registerAPIs;

/**
 *  分发到具体渠道去分享
 *
 *  @param chanel  渠道
 *  @param message 消息
 */
+ (void)shareToChannel:(ShareChanel)chanel withMessage:(SShareMessage *)message completion:(SShareMCompletionBlock)block;


+ (void)handleOpenUrl:(NSURL *)url completion:(SShareMCompletionBlock)block;


+ (BOOL)isCanShareInWeiboAPP;

@end
