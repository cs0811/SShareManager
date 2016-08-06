//
//  SShareSinaHandle.m
//  SShareManager
//
//  Created by tongxuan on 16/8/3.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SShareSinaHandle.h"
#import "WeiboSDK.h"

static SShareCompletionBlock _respBlock;

@interface SShareSinaHandle ()<WeiboSDKDelegate>

@end

@implementation SShareSinaHandle

+ (BOOL)canBeOpen {
    return YES;
}

+ (BOOL)registerAPIs {
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kShare_SinaKey];
    
    return YES;
}

+ (void)shareMessage:(SShareMessage *)message toType:(ShareToType)type completion:(SShareCompletionBlock)block {
    
    if (type == ShareTo_Friend) {
        WBMessageObject *wbMessage = [WBMessageObject message];
        if ([message.webUrl notNull]) {
            // 分享多网址
            WBWebpageObject *webpage = [WBWebpageObject object];
            webpage.objectID = message.webUrl;
            webpage.title = message.title?:@"";
            webpage.description = message.content?:@"";
            webpage.thumbnailData = [UIImage zipImageWithImage:message.image];
            webpage.webpageUrl = message.webUrl;
            wbMessage.mediaObject = webpage;
        }else if (message.image) {
            // 分享图片
            WBImageObject *image = [WBImageObject object];
            image.imageData = UIImageJPEGRepresentation(message.image, 0.7);
            wbMessage.imageObject = image;
        }else {
            // 分享文字
            if ([message.content notNull]) {
                wbMessage.text = message.content;
            }else {
                wbMessage.text = message.title;
            }
        }
        
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = @"http://marrymemo.com";
        authRequest.scope = @"all";
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:wbMessage authInfo:authRequest access_token:nil];
        [WeiboSDK sendRequest:request];
    }else if (type == shareTo_TimeLine) {
    }
}

+ (void)handleOpenUrl:(NSURL *)url completion:(SShareCompletionBlock)block {
    NSLog(@"wbUrl -- %@",url.absoluteString);
    // wb2726144177://response?id=BFA9DC72-51CD-40C4-942F-18758C683F7B&sdkversion=2.5
    _respBlock = block;
    SShareSinaHandle * sinaHandle = [SShareSinaHandle new];
    [WeiboSDK handleOpenURL:url delegate:sinaHandle];
}

#pragma mark WeiboSDKDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    NSLog(@"userInfo -- %@ \n staus -- %ld",response.userInfo,(long)response.statusCode);
//    WeiboSDKResponseStatusCodeSuccess               = 0,//成功
//    WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
//    WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
//    WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
//    WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
//    WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
//    WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
//    WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
//    WeiboSDKResponseStatusCodeUnknown               = -100,
//    
    SShareReusltCode code = SShareReuslt_Unknown;
    NSString * error = @"";
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        // 成功
        code = SShareReuslt_Success;
        error = @"分享成功";
    }else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
        // 用户取消
        code = SShareReuslt_UserCancel;
        error = @"分享取消";
    }else if (response.statusCode == WeiboSDKResponseStatusCodeShareInSDKFailed || response.statusCode == WeiboSDKResponseStatusCodeSentFail || response.statusCode == WeiboSDKResponseStatusCodeAuthDeny || response.statusCode == WeiboSDKResponseStatusCodeUnsupport) {
        // 失败
        code = SShareReuslt_Failed;
        if (response.statusCode == WeiboSDKResponseStatusCodeShareInSDKFailed) {
            error = [NSString stringWithFormat:@"分享失败:%@",response.userInfo?:@""];
        }else if (response.statusCode == WeiboSDKResponseStatusCodeSentFail) {
            error = @"分享失败:发送失败";
        }else if (response.statusCode == WeiboSDKResponseStatusCodeAuthDeny) {
            error = @"分享失败:授权失败";
        }else if (response.statusCode == WeiboSDKResponseStatusCodeUnsupport) {
            error = @"分享失败:不支持的请求";
        }
    }else {
        // 未知
        code = SShareReuslt_Unknown;
        error = @"";
    }
    
    _respBlock(code,error);
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

@end
