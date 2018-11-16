//
//  IMPhotoEditingViewController.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoEditingViewController.h"
#import <Masonry.h>
#import "IMPhotoEditingMaskView.h"
#import "IMPhotoEditingFooterView.h"

#define DefaultMaxZoomScale 2.f

@interface IMPhotoEditingViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) IMPhoto *photo;
@property (nonatomic, strong) IMPBPhotoSelectEvent selectEvent;
@property (nonatomic, assign) IMPhotoEditingStyle editingStyle;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) IMPhotoEditingMaskView *editingMaskView;
@property (nonatomic, strong) IMPhotoEditingFooterView *footerView;

@end

@implementation IMPhotoEditingViewController

- (instancetype)initWithPhoto:(IMPhoto *)photo editingStype:(IMPhotoEditingStyle)editingStyle selectEvent:(nonnull IMPBPhotoSelectEvent)selectEvent {
    if (self = [super init]) {
        self.photo = photo;
        self.editingStyle = editingStyle;
        self.selectEvent = selectEvent;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = UIColor.blackColor;
    
    _editingMaskView = [[IMPhotoEditingMaskView alloc] initWithEditingStyle:self.editingStyle frame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds))];
    _editingMaskView.userInteractionEnabled = NO;
    [self.view addSubview:_editingMaskView];
    
//    _scrollView = [[UIScrollView alloc] initWithFrame:_editingMaskView.clipRect];
    _scrollView = [[UIScrollView alloc] initWithFrame:_editingMaskView.frame];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1.f;
    _scrollView.maximumZoomScale = DefaultMaxZoomScale;
    _scrollView.clipsToBounds = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view insertSubview:_scrollView belowSubview:_editingMaskView];
    
    _imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
    [_scrollView addSubview:_imageView];
    
    
    _footerView = [[IMPhotoEditingFooterView alloc] init];
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
}

#pragma mark - 设置最大缩放比
- (void)setMaxZoomScale {
    if (!self.imageView.image) return;
    CGFloat showAreaW = CGRectGetWidth(self.editingMaskView.clipRect);
    CGFloat showAreaH = CGRectGetHeight(self.editingMaskView.clipRect);
    CGSize imgSize = self.imageView.image.size;
    CGFloat widthRatio = imgSize.width / showAreaW;
    CGFloat heightRatio = imgSize.height / showAreaH;
    CGFloat ratio = MIN(widthRatio, heightRatio);
    CGFloat imgViewW = imgSize.width / ratio;
    CGFloat imgViewH = imgSize.height / ratio;
    self.imageView.frame = CGRectMake(0, 0, imgViewW, imgViewH);
    if (ratio <= DefaultMaxZoomScale) {
         self.scrollView.maximumZoomScale = DefaultMaxZoomScale;
     } else {
         self.scrollView.maximumZoomScale = ratio;
     }
    [self.scrollView setContentInset:self.editingMaskView.clipRectMargin];
    [self.scrollView setContentOffset:(CGPointMake((imgViewW - CGRectGetWidth(self.scrollView.bounds)) / 2, (imgViewH - CGRectGetHeight(self.scrollView.bounds)) / 2))];
}

#pragma mark - UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [scrollView setZoomScale:scale animated:NO];
}

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
    CGRect clipRect = [self.editingMaskView convertRect:self.editingMaskView.clipRect toView:self.imageView];
    CGFloat radio = self.imageView.image.size.width / CGRectGetWidth(self.imageView.bounds);
    clipRect = CGRectMake(clipRect.origin.x * radio, clipRect.origin.y * radio, clipRect.size.width * radio, clipRect.size.height * radio);
    UIImage *image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.imageView.image.CGImage, clipRect)];
    _photo.image = image;
    _photo.thumbImage = image;
    _photo.isEditing = YES;
    if (_selectEvent) {
        _selectEvent(_photo);
    }
}

#pragma mark - 关闭
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
