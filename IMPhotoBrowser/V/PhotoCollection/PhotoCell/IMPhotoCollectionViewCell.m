//
//  IMPhotoCollectionViewCell.m
//  IMPhotoBrowser
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoCollectionViewCell.h"
#import "IMPhoto.h"

@interface IMPhotoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic, strong) PHImageRequestOptions *imgRequestOptions;

@end

@implementation IMPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_imgView setTintColor:UIColor.lightGrayColor];
}

- (void)setPhoto:(IMPhoto *)photo {
    _photo = photo;
    [self.imgView setContentMode:UIViewContentModeScaleAspectFill];
    self.maskView.hidden = _photo.selected || !self.disableSelect;
    if (_photo.thumbImage) {
        self.imgView.image = _photo.thumbImage;
    } else {
        self.imgView.image = _photo.image;
        if (_photo.asset) {
            __weak typeof(self) weakSelf = self;
            [[PHImageManager defaultManager] requestImageForAsset:_photo.asset targetSize:self.bounds.size contentMode:PHImageContentModeAspectFill options:self.imgRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                weakSelf.imgView.image = result;
                weakSelf.photo.thumbImage = result;
            }];
        }
    }
    self.selectBtn.selected = _photo.selected;
}

- (void)setHideSelectBtn:(BOOL)hideSelectBtn {
    _hideSelectBtn = hideSelectBtn;
    self.selectBtn.hidden = _hideSelectBtn;
}

- (PHImageRequestOptions *)imgRequestOptions {
    if (!_imgRequestOptions) {
        _imgRequestOptions = [[PHImageRequestOptions alloc] init];
        _imgRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
        _imgRequestOptions.networkAccessAllowed = YES;
    }
    return _imgRequestOptions;
}

- (IBAction)selectBtnClick {
    self.selectBtn.selected = !self.selectBtn.selected;
    _photo.selected = self.selectBtn.selected;
    if (_photoSelectEvent) {
        _photoSelectEvent(_photo);
    }
}

@end
