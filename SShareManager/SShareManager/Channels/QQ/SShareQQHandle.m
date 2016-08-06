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

static SShareCompletionBlock _respBlock;

@interface SShareQQHandle ()<QQApiInterfaceDelegate>

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

+ (void)shareMessage:(SShareMessage *)message toType:(ShareToType)type completion:(SShareCompletionBlock)block {
    if (type == ShareTo_Friend) {
        
    }else if (type == shareTo_TimeLine) {
    }
    
    if ([message.webUrl notNull]) {
        // 分享网址
        QQApiNewsObject *webObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:message.webUrl] title:message.title description:message.content previewImageData:[UIImage zipImageWithImage:message.image] targetContentType:QQApiURLTargetTypeNews];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:webObj];
        [QQApiInterface sendReq:req];
    }else if (message.image) {
        // 分享图片
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImageJPEGRepresentation(message.image, 1) previewImageData:[UIImage zipImageWithImage:message.image] title:message.title description:message.content];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        [QQApiInterface sendReq:req];
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
        [QQApiInterface sendReq:req];
    }
}

+ (void)handleOpenUrl:(NSURL *)url completion:(SShareCompletionBlock)block {
    _respBlock = block;
    SShareQQHandle * qqHandle = [SShareQQHandle new];
    [QQApiInterface handleOpenURL:url delegate:qqHandle];
    // tencent100370679://response_from_qq?source=qq&source_scheme=mqqapi&error=0&version=1
    NSLog(@"qqUrl -- %@",url.absoluteString);
}

#pragma mark QQApiInterfaceDelegate
- (void)onResp:(QQBaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        NSLog(@"result -- %@ \n errorDescription -- %@ \n ext -- %@",resp.result,resp.errorDescription,resp.extendInfo);
        
        //    EQQAPISENDSUCESS = 0,
        //    EQQAPIQQNOTINSTALLED = 1,
        //    EQQAPIQQNOTSUPPORTAPI = 2,
        //    EQQAPIMESSAGETYPEINVALID = 3,
        //    EQQAPIMESSAGECONTENTNULL = 4,
        //    EQQAPIMESSAGECONTENTINVALID = 5,
        //    EQQAPIAPPNOTREGISTED = 6,
        //    EQQAPIAPPSHAREASYNC = 7,
        //    EQQAPIQQNOTSUPPORTAPI_WITH_ERRORSHOW = 8,
        //    EQQAPISENDFAILD = -1,
        //    //qzone分享不支持text类型分享
        //    EQQAPIQZONENOTSUPPORTTEXT = 10000,
        //    //qzone分享不支持image类型分享
        //    EQQAPIQZONENOTSUPPORTIMAGE = 10001,
        //    //当前QQ版本太低，需要更新至新版本才可以支持
        //    EQQAPIVERSIONNEEDUPDATE = 10002,
        SShareReusltCode code = SShareReuslt_Unknown;
        QQApiSendResultCode tempCode = resp.result.intValue;
        NSString * error = @"";
        
        if (tempCode == EQQAPISENDSUCESS) {
            // 成功
            code = SShareReuslt_Success;
            error = @"分享成功";
        }else {
            // 失败
            code = SShareReuslt_Failed;
            if (tempCode == EQQAPIMESSAGETYPEINVALID) {
                error = @"分享失败:参数错误";
            }else if (tempCode == EQQAPISENDFAILD) {
                error = @"分享失败:发送失败";
            }else {
                error = @"分享失败";
            }
        }
        _respBlock(code,error);
    }
}

- (void)onReq:(QQBaseReq *)req {
    
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}
@end
