//
//  IMPhoto.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhoto.h"

@implementation IMPhoto

+ (instancetype)photoWithAsset:(PHAsset *)asset {
    IMPhoto *photo = [[IMPhoto alloc] init];
    photo.asset = asset;
    return photo;
}

+ (instancetype)photoWithImage:(UIImage *)image {
    IMPhoto *photo = [[IMPhoto alloc] init];
    photo.image = image;
    return photo;
}

- (void)getImageByAsset {
    if (!_asset) return;
    __weak typeof(self) weakSelf = self;
    [PHImageManager.defaultManager requestImageForAsset:_asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weakSelf.image = result;
    }];
}

- (void)getImageByAssetWithResult:(void (^)(UIImage * _Nullable))resultBlock {
    if (!_asset) return;
    if (!resultBlock) return;
    [PHImageManager.defaultManager requestImageForAsset:_asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultBlock(result);
    }];
}

@end
