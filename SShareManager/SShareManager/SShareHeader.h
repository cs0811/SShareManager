//
//  SShareHeader.h
//  SShareManager
//
//  Created by tongxuan on 16/6/24.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#ifndef SShareHeader_h
#define SShareHeader_h

#define WS      __weak typeof(self) wself = self;
#define SS      __strong typeof(wself) sself = wself;
#define kScreenW    [UIScreen mainScreen].bounds.size.width
#define kScreenH    [UIScreen mainScreen].bounds.size.height

// import
#import "SShare.h"
#import "NSString+NotNull.h"
#import "UIImage+Compress.h"


// key
#define kShare_QQID                 @"100370679"
#define kShare_WXKey                @"wx9acfc1464c57b9b4"
#define kShare_SinaKey              @"2726144177"

// icon
#define kWX_FriendIcon              @"refresh"
#define kWX_TimeLineIcon            @"refresh"
#define kQQ_FriendIcon              @"refresh"
#define KSinaIcon                   @"refresh"

#endif /* SShareHeader_h */
