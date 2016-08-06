//
//  SShareBaseHandle.h
//  SShareManager
//
//  Created by tongxuan on 16/8/3.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SShareHeader.h"

typedef NS_ENUM(NSInteger,ShareToType) {
    ShareTo_Friend = 0,         // 好友
    shareTo_TimeLine ,          // 朋友圈
};

@class SShareMessage;

@interface SShareBaseHandle : NSObject

+ (BOOL)registerAPIs;

+ (BOOL)canBeOpen;

+ (void)shareMessage:(SShareMessage *)message toType:(ShareToType)type completion:(SShareCompletionBlock)block;

+ (void)handleOpenUrl:(NSURL *)url completion:(SShareCompletionBlock)block;
@end
