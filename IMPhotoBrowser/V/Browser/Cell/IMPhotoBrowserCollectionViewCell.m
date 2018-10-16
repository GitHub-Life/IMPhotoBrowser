//
//  IMPhotoBrowserCollectionViewCell.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/13.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoBrowserCollectionViewCell.h"
#import "IMPhoto.h"

#define DefaultMaxZoomScale 2.f

@interface IMPhotoBrowserCollectionViewCell () <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat cellW;
@property (nonatomic, assign) CGFloat cellH;

@end

@implementation IMPhotoBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.f;
        _scrollView.maximumZoomScale = DefaultMaxZoomScale;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    }
    return _imageView;
}

- (void)initView {
    [self addSubview:self.scrollView];
    _cellW = CGRectGetWidth(self.bounds);
    _cellH = CGRectGetHeight(self.bounds);
    [self.scrollView addSubview:self.imageView];
    
    UITapGestureRecognizer *singleTapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapEvent:)];
    singleTapGr.numberOfTapsRequired = 1;
    singleTapGr.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTapGr];
    UITapGestureRecognizer *doubleTapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapEvent:)];
    doubleTapGr.numberOfTapsRequired = 2;
    doubleTapGr.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTapGr];
    [singleTapGr requireGestureRecognizerToFail:doubleTapGr];
}

- (void)setPhoto:(IMPhoto *)photo {
    _photo = photo;
    if (_photo.image) {
        self.imageView.image = _photo.image;
    } else {
        self.imageView.image = _photo.thumbImage;
        if (_photo.asset) {
            __weak typeof(self) weakSelf = self;
            [_photo getImageByAssetWithResult:^(UIImage * _Nullable image) {
                weakSelf.imageView.image = image;
                [self setBothZoomScale];
            }];
        }
    }
    [self setBothZoomScale];
    [self.scrollView setZoomScale:1.f];
    [self.scrollView setContentOffset:(CGPointZero)];
}

- (void)setBothZoomScale {
    if (!self.imageView.image) return;
    CGSize imgSize = self.imageView.image.size;
    CGFloat widthRatio = imgSize.width / self.cellW;
    CGFloat heightRatio = imgSize.height / self.cellH;
    CGFloat ratio = MAX(widthRatio, heightRatio);
    CGFloat imgViewW = imgSize.width / ratio;
    CGFloat imgViewH = imgSize.height / ratio;
    CGFloat offsetX = (self.cellW - imgViewW) / 2;
    CGFloat offsetY = (self.cellH - imgViewH) / 2;
    self.imageView.frame = CGRectMake(offsetX, offsetY, imgViewW, imgViewH);
    if (ratio <= 1.f) {
        self.scrollView.maximumZoomScale = 1.f;
    } else if (ratio <= DefaultMaxZoomScale) {
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
    CGFloat offsetX = (self.cellW > scrollView.contentSize.width) ? (self.cellW - scrollView.contentSize.width) / 2 : 0.f;
    CGFloat offsetY = (self.cellH > scrollView.contentSize.height) ? (self.cellH - scrollView.contentSize.height) / 2 : 0.F;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - 自定义手势
- (void)singleTapEvent:(UITapGestureRecognizer *)tapGr {
    if (_singleTapEvent) {
        _singleTapEvent();
    }
}

- (void)doubleTapEvent:(UITapGestureRecognizer *)tapGr {
    if (self.scrollView.zoomScale >= self.scrollView.maximumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    }
}

@end
