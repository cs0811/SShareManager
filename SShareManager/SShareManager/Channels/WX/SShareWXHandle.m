//
//  SShareWXHandle.m
//  SShareManager
//
//  Created by tongxuan on 16/8/3.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SShareWXHandle.h"
#import "WXApi.h"

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

+ (void)shareMessage:(SShareMessage *)message toType:(ShareToType)type {
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

+ (void)handleOpenUrl:(NSURL *)url {
    SShareWXHandle * wxHandel = [SShareWXHandle new];
    [WXApi handleOpenURL:url delegate:wxHandel];
}

#pragma mark WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp * result = (SendMessageToWXResp *)resp;
        NSLog(@"lang --%@ \n country --%@ \n errCode --%d",result.lang,result.country,resp.errCode);
    }
}

@end
