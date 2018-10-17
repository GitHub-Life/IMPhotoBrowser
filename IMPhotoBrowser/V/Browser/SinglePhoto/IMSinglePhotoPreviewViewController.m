//
//  IMSinglePhotoPreviewViewController.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMSinglePhotoPreviewViewController.h"
#import <Masonry.h>
#import "IMPhoto.h"
#import "IMPhotoEditingMaskView.h"
#import "IMSinglePhotoPreviewFooterView.h"

#define DefaultMaxZoomScale 2.f

@interface IMSinglePhotoPreviewViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) IMPhoto *photo;
@property (nonatomic, strong) IMPBPhotoBrowseFinishEvent browseFinish;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) IMPhotoEditingMaskView *editingMaskView;
@property (nonatomic, strong) IMSinglePhotoPreviewFooterView *footerView;

@property (nonatomic, assign) CGFloat screenW;
@property (nonatomic, assign) CGFloat screenH;

@end

@implementation IMSinglePhotoPreviewViewController

- (instancetype)initWithPhoto:(IMPhoto *)photo browseFinish:(nonnull IMPBPhotoBrowseFinishEvent)browseFinish {
    if (self = [super init]) {
        self.photo = photo;
        self.browseFinish = browseFinish;
        self.animationTransitioning.currentIndex = _photo.index;
        self.transitioningDelegate = self.animationTransitioning;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (IMPhotoBrowserAnimationTransitioning *)animationTransitioning {
    if (!_animationTransitioning) {
        _animationTransitioning = [[IMPhotoBrowserAnimationTransitioning alloc] init];
        [_animationTransitioning addPanGerstureForTargetView:self.view dismissVC:self];
        __weak typeof(self) weakSelf = self;
        [_animationTransitioning setTargetViewBlock:^UIView *(NSInteger index){
            if (weakSelf.scrollView.zoomScale != 1.f) return nil;
            return weakSelf.imageView;
        }];
    }
    return _animationTransitioning;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = UIColor.blackColor;
    _screenW = CGRectGetWidth(UIScreen.mainScreen.bounds);
    _screenH = CGRectGetHeight(UIScreen.mainScreen.bounds);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _screenW, _screenH)];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1.f;
    _scrollView.maximumZoomScale = DefaultMaxZoomScale;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
    [_scrollView addSubview:_imageView];
    
    _editingMaskView = [[IMPhotoEditingMaskView alloc] initWithFrame:CGRectMake(0, 0, _screenW, _screenH)];
    [self.view addSubview:_editingMaskView];
    
    _footerView = [[IMSinglePhotoPreviewFooterView alloc] init];
    [_footerView.cancelBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_footerView.completeBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_footerView];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer *doubleTapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapEvent:)];
    doubleTapGr.numberOfTapsRequired = 2;
    doubleTapGr.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:doubleTapGr];
    [self showPhoto];
}

- (void)showPhoto {
    if (_photo.image) {
        self.imageView.image = _photo.image;
    } else {
        self.imageView.image = _photo.thumbImage;
        __weak typeof(self) weakSelf = self;
        [_photo getImageWithResult:^(UIImage * _Nullable image) {
            weakSelf.imageView.image = image;
            [weakSelf setMaxZoomScale];
        }];
    }
    [self setMaxZoomScale];
    [self.scrollView setZoomScale:1.f];
    [self.scrollView setContentOffset:(CGPointZero)];
}

#pragma mark - 设置最大缩放比
- (void)setMaxZoomScale {
    if (!self.imageView.image) return;
    CGSize imgSize = self.imageView.image.size;
    CGFloat widthRatio = imgSize.width / self.screenW;
    CGFloat heightRatio = imgSize.height / self.screenH;
    CGFloat ratio = MAX(widthRatio, heightRatio);
    CGFloat imgViewW = imgSize.width / ratio;
    CGFloat imgViewH = imgSize.height / ratio;
    CGFloat offsetX = (self.screenW - imgViewW) / 2;
    CGFloat offsetY = (self.screenH - imgViewH) / 2;
    self.imageView.frame = CGRectMake(offsetX, offsetY, imgViewW, imgViewH);
    /*if (ratio <= 1.f) {
     self.scrollView.maximumZoomScale = 1.f;
     } else */if (ratio <= DefaultMaxZoomScale) {
         self.scrollView.maximumZoomScale = DefaultMaxZoomScale;
     } else {
         self.scrollView.maximumZoomScale = ratio;
     }
}

#pragma mark - UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [scrollView setZoomScale:scale animated:NO];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (self.screenW > scrollView.contentSize.width) ? (self.screenW - scrollView.contentSize.width) / 2 : 0.f;
    CGFloat offsetY = (self.screenH > scrollView.contentSize.height) ? (self.screenH - scrollView.contentSize.height) / 2 : 0.F;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - 自定义手势
- (void)doubleTapEvent:(UITapGestureRecognizer *)tapGr {
    if (self.scrollView.zoomScale >= self.scrollView.maximumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    }
}

#pragma mark - 完成
- (void)complete {
    [self close];
    CGRect clipRect = [self.editingMaskView convertRect:self.editingMaskView.clipRect toView:self.view];
    _photo.image = [self imageWithView:self.view clipRect:clipRect];
    _photo.thumbImage = _photo.image;
    if (_browseFinish) {
        _browseFinish(_photo.index);
    }
}

- (UIImage *)imageWithView:(UIView *)view clipRect:(CGRect)clipRect {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    UIRectClip(clipRect);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - 关闭
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
