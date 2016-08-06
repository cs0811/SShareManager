//
//  SShareWXHandle.m
//  SShareManager
//
//  Created by tongxuan on 16/8/3.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SShareWXHandle.h"
#import "WXApi.h"

static SShareCompletionBlock _respBlock;

@interface SShareWXHandle ()<WXApiDelegate>

@end

@implementation SShareWXHandle

+ (BOOL)canBeOpen {
    return YES;
}

// 没有网页版，需要判断是否安装微信
+ (BOOL)registerAPIs {
    [WXApi registerApp:kShare_WXKey];
    return [WXApi isWXAppInstalled];
}

+ (void)shareMessage:(SShareMessage *)message toType:(ShareToType)type completion:(SShareCompletionBlock)block {
    CGFloat scene = 0;
    if (type == ShareTo_Friend) {
        scene = WXSceneSession;
    }else if (type == shareTo_TimeLine) {
        scene = WXSceneTimeline;
    }
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = scene;
    if ([message.webUrl notNull]) {
        // 分享网址
        WXMediaMessage *wxMessage = [WXMediaMessage message];
        [wxMessage setThumbData:[UIImage zipImageWithImage:message.image]];
        wxMessage.title = message.title;
        wxMessage.description = message.content;
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = message.webUrl;
        wxMessage.mediaObject = ext;
        req.bText = NO;
        req.message =wxMessage;
    }else if (message.image) {
        // 分享图片
        WXMediaMessage *wxMessage = [WXMediaMessage message];
        [wxMessage setThumbData:[UIImage zipImageWithImage:message.image]];
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = UIImageJPEGRepresentation(message.image, 1);
        wxMessage.mediaObject = ext;
        req.bText = NO;
        req.message =wxMessage;
    }else {
        // 分享文字
        req.bText = YES;
        if ([message.content notNull]) {
            req.text = message.content;
        }else {
            req.text = message.title;
        }
    }
    [WXApi sendReq:req];
}

+ (void)handleOpenUrl:(NSURL *)url completion:(SShareCompletionBlock)block {
    NSLog(@"wxUrl -- %@",url.absoluteString);
    // wx9acfc1464c57b9b4://platformId=wechat
    _respBlock = block;
    SShareWXHandle * wxHandel = [SShareWXHandle new];
    [WXApi handleOpenURL:url delegate:wxHandel];
}

#pragma mark WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp * result = (SendMessageToWXResp *)resp;
        NSLog(@"lang --%@ \n country --%@ \n errCode --%d",result.lang,result.country,resp.errCode);
        
//        SShareReuslt_Unknown    = 0,        // 未知
//        SShareReuslt_Success ,              // 成功
//        SShareReuslt_UserCancel ,           // 用户取消
//        SShareReuslt_Failed     ,           // 失败
        
        SShareReusltCode code = SShareReuslt_Unknown;
        NSString * error = @"";
        if (resp.errCode == WXSuccess) {
            // 成功
            code = SShareReuslt_Success;
            error = @"分享成功";
        }else if (resp.errCode == WXErrCodeUserCancel) {
            // 用户取消
            code = SShareReuslt_UserCancel;
            error = @"分享取消";
        }else if (resp.errCode == WXErrCodeCommon || resp.errCode == WXErrCodeSentFail) {
            // 失败
            code = SShareReuslt_Failed;
            if (resp.errCode == WXErrCodeCommon) {
                error = @"分享失败:普通错误类型";
            }else if (resp.errCode == WXErrCodeSentFail) {
                error = @"分享失败:发送失败";
            }
        }else {
            // 未知
            code = SShareReuslt_Unknown;
            error = @"";
        }
        
        _respBlock(code,error);
    }
}

@end
