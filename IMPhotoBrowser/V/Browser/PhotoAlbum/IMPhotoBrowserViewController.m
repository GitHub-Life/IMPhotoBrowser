//
//  IMPhotoBrowserViewController.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/13.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoBrowserViewController.h"
#import <Masonry.h>
#import "UIViewController+IMAlert.h"
#import "IMPhotoBrowserCollectionView.h"
#import "IMPhotoBrowserHeaderFooterView.h"
#import "IMPBSelectedStateButton.h"

@interface IMPhotoBrowserViewController ()

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, strong) IMPhotoBrowserCollectionView *collectionView;

@property (nonatomic, strong) IMPhotoBrowserHeaderFooterView *headerView;
@property (nonatomic, strong) IMPBSelectedStateButton *selectedStateBtn;

@property (nonatomic, assign) BOOL completed;

@end

@implementation IMPhotoBrowserViewController

#pragma mark - 初始化
- (instancetype)initWithPhotoArray:(NSArray<IMPhoto *> *)photoArray currentIndex:(NSInteger)currentIndex maxCount:(NSInteger)maxCount {
    if (self = [super init]) {
        self.collectionView.photoArray = photoArray;
        self.headerView.currentIndex = currentIndex;
        self.maxCount = maxCount;
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

- (IMPhotoBrowserHeaderFooterView *)headerView {
    if (!_headerView) {
        _headerView = [[IMPhotoBrowserHeaderFooterView alloc] initWithTotalCount:self.collectionView.photoArray.count];
        [_headerView.rightBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (IMPBSelectedStateButton *)selectedStateBtn {
    if (!_selectedStateBtn) {
        _selectedStateBtn = [IMPBSelectedStateButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_selectedStateBtn];
        __weak typeof(self) weakSelf = self;
        [_selectedStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50.f, 50.f));
            make.trailing.mas_equalTo(0);
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.mas_equalTo(0);
            }
        }];
        [_selectedStateBtn addTarget:self action:@selector(selectStateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedStateBtn;
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
        weakSelf.headerView.currentIndex = page;
        weakSelf.selectedStateBtn.selected = weakSelf.collectionView.photoArray[page].selected;
        weakSelf.animationTransitioning.currentIndex = page;
    }];
    [self.headerView addToTargetView:self.view];
    
    self.selectedStateBtn.selected = self.collectionView.photoArray[self.headerView.currentIndex].selected;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView setSelectedIndex:weakSelf.headerView.currentIndex];
    });
}

- (void)selectStateBtnClick {
    self.collectionView.currentPhoto.selected = !self.collectionView.currentPhoto.selected;
    if ([self checkSelectedPhotoCount]) {
        self.selectedStateBtn.selected = !self.selectedStateBtn.selected;
        self.collectionView.currentPhoto.selected = self.selectedStateBtn.selected;
    } else {
        self.collectionView.currentPhoto.selected = !self.collectionView.currentPhoto.selected;
    }
}

- (void)coverView:(BOOL)show {
    if (show && self.headerView.hidden) {
        self.headerView.hidden = NO;
        self.selectedStateBtn.hidden = NO;
        [UIApplication.sharedApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:0.3 animations:^{
            self.headerView.transform = CGAffineTransformIdentity;
            self.selectedStateBtn.transform = CGAffineTransformIdentity;
        }];
    } else if (!show && !self.headerView.hidden) {
        [UIApplication.sharedApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:0.3 animations:^{
            self.headerView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.headerView.bounds));
            self.selectedStateBtn.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.selectedStateBtn.bounds), 0);
        } completion:^(BOOL finished) {
            self.headerView.hidden = YES;
            self.selectedStateBtn.hidden = YES;
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkSelectedPhotoCount];
}

#pragma mark - 检查选中的照片数量
- (BOOL)checkSelectedPhotoCount {
    if (!self.photoSelectEvent) return NO;
    NSInteger selectedPhotoCount = self.photoSelectEvent(self.collectionView.currentPhoto);
    if (selectedPhotoCount < 0) {
        // 这里如果为-1，表示选择图片不成功
        [self alertMessage:[NSString stringWithFormat:@"当前最多选择%d张图片", (int)self.maxCount]];
        return NO;
    }
    if (selectedPhotoCount > 0) {
        [self.headerView.rightBtn setTitle:[NSString stringWithFormat:@"完成(%d)", (int)selectedPhotoCount] forState:UIControlStateNormal];
    } else {
        [self.headerView.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    return YES;
}

#pragma mark - 完成预览
- (void)complete {
    [self dismissViewControllerAnimated:YES completion:nil];
    _completed = YES;
    if (_browseFinish) {
        _browseFinish(-100); // <0代表是点击Complete按钮
    }
}

#pragma mark - 关闭预览
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication.sharedApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!_completed && _browseFinish) {
        _browseFinish(self.collectionView.currentIndex);
    }
}
     
@end
