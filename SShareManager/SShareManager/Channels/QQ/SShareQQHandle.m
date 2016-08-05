//
//  SShareQQHandle.m
//  SShareManager
//
//  Created by tongxuan on 16/8/3.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SShareQQHandle.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface SShareQQHandle ()

@end

@implementation SShareQQHandle

+ (BOOL)canBeOpen {
    return YES;
}

// 没有网页版，需要判断是否安装QQ
+ (BOOL)registerAPIs {
//    SShareQQHandle * qqHandle = [SShareQQHandle new];
    id reusult = [[TencentOAuth alloc] initWithAppId:kShare_QQID andDelegate:nil]; //注册
    NSLog(@"TencentOAuth -- %@",reusult);
    return [TencentOAuth iphoneQQInstalled];
}

+ (void)shareMessage:(SShareMessage *)message toType:(ShareToType)type {
    if (type == ShareTo_Friend) {
        
    }else if (type == shareTo_TimeLine) {
    }
    
    if ([message.webUrl notNull]) {
        // 分享网址
        QQApiNewsObject *webObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:message.webUrl] title:message.title description:message.content previewImageData:[UIImage zipImageWithImage:message.image] targetContentType:QQApiURLTargetTypeNews];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:webObj];
        QQApiSendResultCode send = [QQApiInterface sendReq:req];
        
        NSLog(@"send -- %d",send);
    }else if (message.image) {
        // 分享图片
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImageJPEGRepresentation(message.image, 1) previewImageData:[UIImage zipImageWithImage:message.image] title:message.title description:message.content];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        QQApiSendResultCode send = [QQApiInterface sendReq:req];
        
        NSLog(@"send -- %d",send);
    }else {
        // 分享文字
        NSString * text = @"";
        if ([message.content notNull]) {
            text = message.content;
        }else {
            text = message.title;
        }
        QQApiTextObject *imgObj = [QQApiTextObject objectWithText:text];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        QQApiSendResultCode send = [QQApiInterface sendReq:req];
        NSLog(@"send -- %d",send);
    }
}

+ (void)handleOpenUrl:(NSURL *)url {
    [TencentOAuth HandleOpenURL:url];
}

@end
