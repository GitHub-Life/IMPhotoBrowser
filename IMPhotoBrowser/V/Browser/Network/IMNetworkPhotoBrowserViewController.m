//
//  IMNetworkPhotoBrowserViewController.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMNetworkPhotoBrowserViewController.h"
#import <Masonry.h>
#import "IMPhotoBrowserCollectionView.h"
#import "IMPhotoBrowserHeaderView.h"
#import "IMPhoto.h"

@interface IMNetworkPhotoBrowserViewController ()

@property (nonatomic, strong) IMPhotoBrowserCollectionView *collectionView;

@property (nonatomic, strong) IMPhotoBrowserHeaderView *headerView;

@end

@implementation IMNetworkPhotoBrowserViewController

+ (void)browserPhotoWithParameter:(IMPhotoBrowserParameter *)parameter {
    NSMutableArray<IMPhoto *> *photoArray = [NSMutableArray array];
    if (parameter.imageArray.count) {
        for (UIImage *image in parameter.imageArray) {
            [photoArray addObject:[IMPhoto photoWithImage:image]];
        }
    } else if (parameter.imageUrlStrArray.count) {
        for (NSString *imageUrlStr in parameter.imageUrlStrArray) {
            [photoArray addObject:[IMPhoto photoWithImageUrlStr:imageUrlStr thumbSuffix:parameter.thumbSuffix]];
        }
    }
    if (!photoArray.count) return;
    IMNetworkPhotoBrowserViewController *browserVC = [[IMNetworkPhotoBrowserViewController alloc] initWithPhotoArray:photoArray currentIndex:parameter.currentIndex];
    browserVC.animationTransitioning.originalViewBlock = parameter.originalViewBlock;
    [parameter.callerVC presentViewController:browserVC animated:YES completion:nil];
}

#pragma mark - 初始化
- (instancetype)initWithPhotoArray:(NSArray<IMPhoto *> *)photoArray currentIndex:(NSInteger)currentIndex {
    if (self = [super init]) {
        self.collectionView.photoArray = photoArray;
        self.headerView.currentIndex = currentIndex;
        self.transitioningDelegate = self.animationTransitioning;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

#pragma mark - 懒加载
- (IMPhotoBrowserAnimationTransitioning *)animationTransitioning {
    if (!_animationTransitioning) {
        _animationTransitioning = [[IMPhotoBrowserAnimationTransitioning alloc] init];
        [_animationTransitioning addPanGerstureForTargetView:self.view dismissVC:self];
        __weak typeof(self) weakSelf = self;
        [_animationTransitioning setTargetViewBlock:^UIView *(NSInteger index){
            return weakSelf.collectionView.animView;
        }];
    }
    return _animationTransitioning;
}

- (IMPhotoBrowserCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[IMPhotoBrowserCollectionView alloc] init];
        __weak typeof(self) weakSelf = self;
        [_collectionView setSingleTapEvent:^{
            [weakSelf coverView:weakSelf.headerView.hidden];
        }];
    }
    return _collectionView;
}

- (IMPhotoBrowserHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[IMPhotoBrowserHeaderView alloc] initWithTotalCount:self.collectionView.photoArray.count];
        [_headerView.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_headerView.rightBtn setTitle:@"已保存" forState:UIControlStateDisabled];
        [_headerView.rightBtn addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    [self.view setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    __weak typeof(self) weakSelf = self;
    [self.collectionView setPageChanged:^(NSInteger page) {
        weakSelf.headerView.currentIndex = page;
        weakSelf.animationTransitioning.currentIndex = page;
        weakSelf.headerView.rightBtn.enabled = !weakSelf.collectionView.currentPhoto.saved;
    }];
    [self.headerView addToTargetView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView setSelectedIndex:weakSelf.headerView.currentIndex];
    });
}

- (void)coverView:(BOOL)show {
    if (show && self.headerView.hidden) {
        self.headerView.hidden = NO;
        [UIApplication.sharedApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:0.3 animations:^{
            self.headerView.transform = CGAffineTransformIdentity;
            [self.view setBackgroundColor:UIColor.whiteColor];
        }];
    } else if (!show && !self.headerView.hidden) {
        [UIApplication.sharedApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:0.3 animations:^{
            self.headerView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.headerView.bounds));
            [self.view setBackgroundColor:UIColor.blackColor];
        } completion:^(BOOL finished) {
            self.headerView.hidden = YES;
        }];
    }
}

#pragma mark - 保存图片
- (void)savePhoto {
    __weak typeof(self) weakSelf = self;
    [self.collectionView saveCurrentPhotoWithFromVC:self result:^(BOOL success) {
        if (success) {
            weakSelf.headerView.rightBtn.enabled = NO;
        }
    }];
}

#pragma mark - 关闭预览
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication.sharedApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

@end
