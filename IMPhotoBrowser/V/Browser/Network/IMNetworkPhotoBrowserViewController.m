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
#import "IMPhotoBrowserHeaderFooterView.h"
#import "IMPhoto.h"

@interface IMNetworkPhotoBrowserViewController ()

@property (nonatomic, strong) IMPhotoBrowserCollectionView *collectionView;

@property (nonatomic, strong) IMPhotoBrowserHeaderFooterView *footerView;

@property (nonatomic, assign) BOOL noNeedSave;

@end

@implementation IMNetworkPhotoBrowserViewController

#pragma mark - 构造器
+ (void)browserPhotoWithParameter:(IMPhotoBrowserParameter *)parameter {
    NSMutableArray<IMPhoto *> *photoArray = [NSMutableArray array];
    if (parameter.photoArray.count) {
        photoArray = parameter.photoArray.mutableCopy;
    } else if (parameter.imageArray.count) {
        for (UIImage *image in parameter.imageArray) {
            [photoArray addObject:[IMPhoto photoWithImage:image]];
        }
    } else if (parameter.imageUrlStrArray.count) {
        for (NSString *imageUrlStr in parameter.imageUrlStrArray) {
            [photoArray addObject:[IMPhoto photoWithImageUrlStr:imageUrlStr thumbSuffix:parameter.thumbSuffix]];
        }
    }
    if (!photoArray.count) return;
    IMNetworkPhotoBrowserViewController *browserVC = [[IMNetworkPhotoBrowserViewController alloc] init];
    browserVC.noNeedSave = parameter.noNeedSave;
    browserVC.collectionView.photoArray = photoArray.copy;
    browserVC.footerView.currentIndex = parameter.currentIndex;
    browserVC.transitioningDelegate = browserVC.animationTransitioning;
    browserVC.modalPresentationStyle = UIModalPresentationCustom;
    browserVC.animationTransitioning.originalViewBlock = parameter.originalViewBlock;
    browserVC.animationTransitioning.roundAvatar = parameter.roundAvatar;
    [parameter.callerVC presentViewController:browserVC animated:YES completion:nil];
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
            [weakSelf coverView:weakSelf.footerView.hidden];
        }];
    }
    return _collectionView;
}

- (IMPhotoBrowserHeaderFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[IMPhotoBrowserHeaderFooterView alloc] initWithTotalCount:self.collectionView.photoArray.count];
        _footerView.isFooter = YES;
        [_footerView.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        if (_noNeedSave) {
            _footerView.rightBtn.hidden = YES;
        } else {
            _footerView.rightBtn.hidden = NO;
            [_footerView.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
            [_footerView.rightBtn setTitle:@"已保存" forState:UIControlStateDisabled];
            [_footerView.rightBtn addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _footerView;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    [self.view setBackgroundColor:UIColor.blackColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    __weak typeof(self) weakSelf = self;
    [self.collectionView setPageChanged:^(NSInteger page) {
        weakSelf.footerView.currentIndex = page;
        weakSelf.animationTransitioning.currentIndex = page;
        weakSelf.footerView.rightBtn.enabled = !weakSelf.collectionView.currentPhoto.saved;
    }];
    [self.footerView addToTargetView:self.view];
    
    [self.view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGrEvent:)]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView setSelectedIndex:weakSelf.footerView.currentIndex];
    });
}

- (void)coverView:(BOOL)show {
    if (show && self.footerView.hidden) {
        self.footerView.hidden = NO;
        [UIApplication.sharedApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:0.3 animations:^{
            self.footerView.transform = CGAffineTransformIdentity;
        }];
    } else if (!show && !self.footerView.hidden) {
        [UIApplication.sharedApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:0.3 animations:^{
            self.footerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.footerView.bounds));
        } completion:^(BOOL finished) {
            self.footerView.hidden = YES;
        }];
    }
}

- (void)longGrEvent:(UILongPressGestureRecognizer *)longGr {
    if (!self.footerView.rightBtn.enabled) return;
    UIAlertControllerStyle preferredStyle = UIAlertControllerStyleAlert;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        preferredStyle = UIAlertControllerStyleActionSheet;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:preferredStyle];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf savePhoto];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 保存图片
- (void)savePhoto {
    __weak typeof(self) weakSelf = self;
    [self.collectionView saveCurrentPhotoWithFromVC:self result:^(BOOL success) {
        if (success) {
            weakSelf.footerView.rightBtn.enabled = NO;
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
