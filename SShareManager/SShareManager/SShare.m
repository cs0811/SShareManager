//
//  SShareView.m
//  SShareManager
//
//  Created by tongxuan on 16/6/24.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SShare.h"
#import "SShareViewCell.h"
#import "SShareManager.h"


@implementation SShareMessage
@end

static SShare * share;
static SShareCompletionBlock _completionBlock;

@interface SShare ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) UICollectionView * colletionView;
@property (nonatomic, strong) NSArray * channelsArr;
@property (nonatomic, strong) SShareMessage * message;
@end

@implementation SShare

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerChannels];
        [self loadUI];
    }
    return self;
}


- (void)registerChannels {
    /**
     *  @{@"ShareChannel_QQ_Friend",@"ShareChannel_WX_Friend",@"ShareChannel_WX_TimeLine",@"ShareChannel_Sina"}
     */
    self.channelsArr = [SShareManager registerAPIs];
}

#pragma mark loadUI
- (void)loadUI {
    if (self.channelsArr.count == 0) {
        NSLog(@"没有可用的分享渠道");
        return;
    }
    
    [self addSubview:self.maskView];
    [self addSubview:self.colletionView];
    self.maskView.frame = CGRectMake(0, 0, kScreenW, kScreenH);    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channelsArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SShareViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SShareViewCell" forIndexPath:indexPath];
    [cell loadDataWithDataArr:self.channelsArr indexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect frame = cell.frame;
    cell.frame = CGRectMake(frame.origin.x, frame.origin.y-40, frame.size.width, frame.size.height);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.25 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.frame = frame;
    } completion:^(BOOL finished) {
    }];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString * chanel = self.channelsArr[indexPath.row];
    if ([chanel isEqualToString:ShareChannel_QQ_Friend]) {
        [SShareManager shareToChannel:QQ_Friend withMessage:share.message];
    }else if ([chanel isEqualToString:ShareChannel_WX_Friend]) {
        [SShareManager shareToChannel:WX_Friend withMessage:share.message];
    }else if ([chanel isEqualToString:ShareChannel_WX_TimeLine]) {
        [SShareManager shareToChannel:WX_TimeLine withMessage:share.message];
    }else if ([chanel isEqualToString:ShareChannel_Sina]) {
        [SShareManager shareToChannel:Sina withMessage:share.message];
    }
}

#pragma mark - show
+ (void)showShareViewWithMessage:(SShareMessage *)message completion:(SShareCompletionBlock)block {
    share = [SShare new];
    _completionBlock = block;
    share.message = message;
    UIWindow * mainWindow = [[UIApplication sharedApplication].delegate window];
    [mainWindow addSubview:share];
    [mainWindow bringSubviewToFront:share];
    share.frame = mainWindow.bounds;
    
    CGFloat h = CGRectGetHeight(share.colletionView.frame);
    [UIView animateWithDuration:0.25 animations:^{
        share.colletionView.frame = CGRectMake(0, kScreenH-h, kScreenW, h);
        share.maskView.frame = CGRectMake(0, 0, kScreenW, kScreenH-h);
    }];
}

#pragma mark - hide
- (void)hideShareView {
    CGFloat h = CGRectGetHeight(share.colletionView.frame);
    [UIView animateWithDuration:0.25 animations:^{
        share.colletionView.frame = CGRectMake(0, kScreenH, kScreenW, h);
        share.maskView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark handleOpen
+ (void)handleOpenUrl:(NSURL *)url completion:(SShareCompletionBlock)block {
    _completionBlock = block;
    [share hideShareView];
    [SShareManager handleOpenUrl:url];
}

#pragma mark - getter
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.alpha = 0.6;
        _maskView.backgroundColor = [UIColor lightGrayColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShareView)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}
- (UICollectionView *)colletionView {
    if (!_colletionView) {
        
        long allItems = self.channelsArr.count;
        // 行数
        CGFloat lines = floor(allItems/ShareViewMaxLineNum);
        if (allItems%ShareViewMaxLineNum != 0 ) {
            lines = lines+1;
        }
        CGFloat itemW = 0;
        itemW = (kScreenW-2*ShareViewLeftSpace-(ShareViewMaxLineNum-1)*ShareViewItemSpaceH)/ShareViewMaxLineNum;
        CGFloat ratio = ShareViewItemRatio;
        CGFloat itemH = itemW/ratio;
        CGFloat h = itemH*lines+2*ShareViewTopSpace+(lines-1)*ShareViewItemSpaceV;
        UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.sectionInset = UIEdgeInsetsMake(ShareViewTopSpace, ShareViewLeftSpace, ShareViewTopSpace, ShareViewLeftSpace);
        _colletionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, h) collectionViewLayout:layout];
        _colletionView.dataSource = self;
        _colletionView.delegate = self;
        _colletionView.backgroundColor = [UIColor whiteColor];
        
        [_colletionView registerClass:[SShareViewCell class] forCellWithReuseIdentifier:@"SShareViewCell"];
    }
    return _colletionView;
}


@end
