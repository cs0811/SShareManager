//
//  SShareView.h
//  SShareManager
//
//  Created by tongxuan on 16/6/24.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  item宽高比(宽/高)
 */
#define ShareViewItemRatio          3/4.
/**
 *  左右边距
 */
#define ShareViewLeftSpace           10.
/**
 *  上下边距
 */
#define ShareViewTopSpace            5.
/**
 *  item间距（竖直）
 */
#define ShareViewItemSpaceV          5.
/**
 *  item间距（水平）
 */
#define ShareViewItemSpaceH          10.
/**
 *  每行的最大个数
 */
#define ShareViewMaxLineNum          4

typedef NS_ENUM(NSInteger,SShareReusltCode) {
    SShareReuslt_Unknown    = 0,        // 未知
    SShareReuslt_Success ,              // 成功
    SShareReuslt_UserCancel ,           // 用户取消
    SShareReuslt_Failed     ,           // 失败
};

typedef void(^SShareCompletionBlock)(SShareReusltCode reusltCode, NSString * errorInfo);

@interface SShareMessage : NSObject
@property (nonatomic, copy) NSString * title;
// 单独分享文字时，优先读取content
@property (nonatomic, copy) NSString * content;
// 真实数据图片 (会在内部做压缩处理）
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, copy) NSString * webUrl;
@end

@interface SShare : UIView

+ (void)showShareViewWithMessage:(SShareMessage *)message completion:(SShareCompletionBlock)block;

+ (void)handleOpenUrl:(NSURL *)url completion:(SShareCompletionBlock)block;

@end
