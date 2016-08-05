//
//  SShareSinaHandle.m
//  SShareManager
//
//  Created by tongxuan on 16/8/3.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SShareSinaHandle.h"
#import "WeiboSDK.h"

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

+ (void)shareMessage:(SShareMessage *)message toType:(ShareToType)type {
    
    if (type == ShareTo_Friend) {
        WBMessageObject *wbMessage = [WBMessageObject message];
        if ([message.webUrl notNull]) {
            // 分享多网址
            WBWebpageObject *webpage = [WBWebpageObject object];
            webpage.objectID = @"identifier1";
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

+ (void)handleOpenUrl:(NSURL *)url {
    SShareSinaHandle * sinaHandle = [SShareSinaHandle new];
    [WeiboSDK handleOpenURL:url delegate:sinaHandle];
}

#pragma mark WeiboSDKDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    NSLog(@"userInfo -- %@ \n staus -- %ld",response.userInfo,(long)response.statusCode);
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

@end
