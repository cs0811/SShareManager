//
//  SShareView.m
//  SShareManager
//
//  Created by tongxuan on 16/6/24.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SShareView.h"
#import "SShareViewCell.h"

@interface SShareView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) UICollectionView * colletionView;
@end

@implementation SShareView

+ (instancetype)share {
    static SShareView * obj;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [SShareView new];
    });
    return obj;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    [self addSubview:self.maskView];
    [self addSubview:self.colletionView];
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
        UICollectionViewFlowLayout * flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.itemSize = CGSizeMake(ItemWidth, ItemHeight);
        // 左右边距
        CGFloat leftRightSpace = (kScreenW-ItemWidth*4-MiddleSpacWidth*3)/2;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, leftRightSpace, 10, leftRightSpace);
        flowLayout.minimumLineSpacing = LineSpace;
        flowLayout.minimumInteritemSpacing = MiddleSpacWidth;
        _colletionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 200) collectionViewLayout:flowLayout];
        _colletionView.dataSource = self;
        _colletionView.delegate = self;
        _colletionView.backgroundColor = [UIColor whiteColor];
        
        [_colletionView registerClass:[SShareViewCell class] forCellWithReuseIdentifier:@"SShareViewCell"];
    }
    return _colletionView;
}

#pragma mark - delegate 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SShareViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SShareViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[SShareViewCell alloc]initWithFrame:CGRectMake(0, 0, ItemWidth, ItemHeight)];
    }
    [cell loadDataWithDataArr:@[] indexPath:indexPath];
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
    NSLog(@"22");
}

#pragma mark - show
- (void)showShareView {
    [self hideShareView];
    
    [self.colletionView reloadData];
    
    UIWindow * mainWindow = [[UIApplication sharedApplication].delegate window];
    [mainWindow addSubview:self];
    [mainWindow bringSubviewToFront:self];
        
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainWindow);
    }];
    
    self.colletionView.frame = CGRectMake(0, kScreenH, kScreenW, 200);
    self.maskView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [UIView animateWithDuration:0.25 animations:^{
        self.colletionView.frame = CGRectMake(0, kScreenH-200, kScreenW, 200);
        self.maskView.frame = CGRectMake(0, 0, kScreenW, kScreenH-200);
    }];
    
}

#pragma mark - hide
- (void)hideShareView {
    [self removeFromSuperview];
}


@end
