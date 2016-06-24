//
//  SShareViewCell.m
//  SShareManager
//
//  Created by tongxuan on 16/6/24.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SShareViewCell.h"

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
        _titleLabel.textColor = [UIColor darkTextColor];
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
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself);
        make.top.equalTo(wself.iconImg.mas_bottom).offset(7);
    }];
}

- (void)loadDataWithDataArr:(NSArray *)dataArr indexPath:(NSIndexPath *)indexPath {
    self.titleLabel.text = @"52se";
    self.iconImg.image = [UIImage imageNamed:@"refresh"];
}

@end
