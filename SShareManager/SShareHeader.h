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


#import "SShareView.h"
#import "Masonry.h"


/**
 每一行放4个
 */

// 每个item大小
#define ItemWidth               50.
#define ItemHeight              70.
// 中间站位大小
#define MiddleSpacWidth         50.
// 行间距
#define LineSpace               10.


#endif /* SShareHeader_h */
