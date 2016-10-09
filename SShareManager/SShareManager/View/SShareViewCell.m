//
//  SShareViewCell.m
//  SShareManager
//
//  Created by tongxuan on 16/6/24.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SShareViewCell.h"
#import "Masonry.h"
#import "SShareManager.h"

@interface SShareViewCell ()
@property (nonatomic, strong) UIImageView * iconImg;
@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation SShareViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return  self;
}

#pragma mark - getter
- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [UIImageView new];
        _iconImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImg;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)loadUI {
    WS
    [self addSubview:self.iconImg];
    [self addSubview:self.titleLabel];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(wself);
        make.height.equalTo(wself).multipliedBy(0.6);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself);
        make.top.equalTo(wself.iconImg.mas_bottom);
    }];
}

- (void)loadDataWithDataArr:(NSArray *)dataArr indexPath:(NSIndexPath *)indexPath {
    
    NSString * chanel = dataArr[indexPath.row];
    NSString * title = @"";
    NSString * icon = @"";
    if ([chanel isEqualToString:ShareChannel_QQ_Friend]) {
        title = @"QQ";
        icon = kQQ_FriendIcon;
    }else if ([chanel isEqualToString:ShareChannel_QQ_TimeLine]) {
        title = @"QQ空间";
        icon = kQQ_TimeLineIcon;
    }else if ([chanel isEqualToString:ShareChannel_WX_Friend]) {
        title = @"微信好友";
        icon = kWX_FriendIcon;
    }else if ([chanel isEqualToString:ShareChannel_WX_TimeLine]) {
        title = @"微信朋友圈";
        icon = kWX_TimeLineIcon;
    }else if ([chanel isEqualToString:ShareChannel_Sina]) {
        title = @"新浪微博";
        icon = KSinaIcon;
    }
    
    self.titleLabel.text = title;
    self.iconImg.image = [UIImage imageNamed:icon];
}

@end
