//
//  IMPBPhotoView.m
//  NiuYan
//
//  Created by 万涛 on 2018/10/25.
//  Copyright © 2018 niuyan.com. All rights reserved.
//

#import "IMPBPhotoView.h"
#import <Masonry.h>
#import "UIView+IMLoading.h"
#import "IMNetworkPhotoBrowserViewController.h"
#import "IMPhoto.h"
#import "IMPBXButton.h"

@interface IMPBPhotoView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation IMPBPhotoView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSettings];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initSettings];
    }
    return self;
}

- (void)initSettings {
    _imageView = [[UIImageView alloc] init];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_imageView setClipsToBounds:YES];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoBrowser)]];
}

- (void)setPhoto:(IMPhoto *)photo {
    _photo = photo;
    if (_photo) {
        if (_thumb) {
            self.imageView.image = _photo.thumbImage ?: _photo.placeholderImage;
            if (!_photo.thumbImage) {
                [self im_loading:YES];
                __weak typeof(self) weakSelf = self;
                CGSize size = self.bounds.size;
                if (CGSizeEqualToSize(size, CGSizeZero)) {
                    size = CGSizeMake(90.f, 90.f);
                }
                [_photo getThumbImageWithSize:size result:^(UIImage * _Nullable thumbImage) {
                    [weakSelf im_loading:NO];
                    if (thumbImage) {
                        weakSelf.imageView.image = thumbImage;
                    }
                }];
            }
        } else {
            self.imageView.image = _photo.image ?: (_photo.thumbImage ?: _photo.placeholderImage);
            if (!_photo.image) {
                [self im_loading:YES];
                __weak typeof(self) weakSelf = self;
                [_photo getImageWithResult:^(UIImage * _Nullable image) {
                    [weakSelf im_loading:NO];
                    if (image) {
                        weakSelf.imageView.image = image;
                    }
                }];
            }
        }
    } else {
        self.imageView.image = nil;
    }
}

- (void)photoBrowser {
    if (_tapEvent) {
        _tapEvent(self);
    } else if (_browserCallerVC && _photo) {
        IMPhotoBrowserParameter *parameter = [IMPhotoBrowserParameter parameterWithPhotoArray:@[_photo] currentIndex:0];
        __weak typeof(self) weakSelf = self;
        [parameter setOriginalViewBlock:^UIView *(NSInteger index) {
            return weakSelf;
        }];
        parameter.callerVC = _browserCallerVC;
        [IMNetworkPhotoBrowserViewController browserPhotoWithParameter:parameter];
    }
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        IMPBXButton *xButton = [[IMPBXButton alloc] init];
        xButton.xRedius = 6.f;
        xButton.tintColor = UIColor.whiteColor;
        xButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
        [self addSubview:xButton];
        [xButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25.f, 25.f));
            make.top.mas_equalTo(0);
            make.trailing.mas_equalTo(0);
        }];
        _deleteBtn = xButton;
    }
    return _deleteBtn;
}

- (void)setCanDelete:(BOOL)canDelete {
    if (_canDelete == canDelete) return;
    _canDelete = canDelete;
    if (_canDelete && self.deleteBtn.hidden) {
        self.deleteBtn.hidden = NO;
    } else if (!_canDelete && !self.deleteBtn.hidden) {
        self.deleteBtn.hidden = YES;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!_deleteBtn.hidden && CGRectContainsPoint(_deleteBtn.frame, point)) {
        return [_deleteBtn hitTest:[_deleteBtn convertPoint:point fromView:self] withEvent:event];
    }
    return [super hitTest:point withEvent:event];
}

@end
