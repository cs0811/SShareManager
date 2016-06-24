//
//  SShareViewCell.h
//  SShareManager
//
//  Created by tongxuan on 16/6/24.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SShareHeader.h"

@interface SShareViewCell : UICollectionViewCell

- (void)loadDataWithDataArr:(NSArray *)dataArr indexPath:(NSIndexPath *)indexPath;

@end
