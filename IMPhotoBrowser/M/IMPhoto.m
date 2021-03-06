//
//  IMPhoto.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhoto.h"
#import <SDWebImageDownloader.h>
#import <SDImageCache.h>
#import <SDWebImageManager.h>

@implementation IMPhoto

#pragma mark - 生成器 类方法
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

+ (instancetype)photoWithImageUrlStr:(NSString *)imageUrlStr {
    IMPhoto *photo = [[IMPhoto alloc] init];
    photo.imageUrlStr = imageUrlStr;
    return photo;
}

+ (instancetype)photoWithImageUrlStr:(NSString *)imageUrlStr thumbSuffix:(nonnull NSString *)thumbSuffix {
    IMPhoto *photo = [[IMPhoto alloc] init];
    photo.imageUrlStr = imageUrlStr;
    photo.thumbSuffix = thumbSuffix;
    return photo;
}

+ (instancetype)photoWithImageUrlStr:(NSString *)imageUrlStr placeholderImage:(UIImage *)placeholderImage {
    IMPhoto *photo = [[IMPhoto alloc] init];
    photo.imageUrlStr = imageUrlStr;
    photo.placeholderImage = placeholderImage;
    return photo;
}

#pragma mark - 获取 Image
- (void)getImageWithResult:(void (^)(UIImage * _Nullable))resultBlock {
    if (!resultBlock) return;
    if (_image) {
        resultBlock(_image);
    } else if (_asset) {
        [self getImageByAssetWithResult:resultBlock];
    } else if (_imageUrlStr.length) {
        [self getImageByUrlWithResult:resultBlock];
    }
}

- (void)getImageByAssetWithResult:(void (^)(UIImage * _Nullable))resultBlock {
    if (!_asset || !resultBlock) return;
    __weak typeof(self) weakSelf = self;
    [PHImageManager.defaultManager requestImageForAsset:_asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (![info[@"PHImageResultIsDegradedKey"] boolValue]) {
            resultBlock(result);
            if (weakSelf.holdImage) {
                weakSelf.image = result;
            }
        }
    }];
}

- (void)getImageByUrlWithResult:(void (^)(UIImage * _Nullable))resultBlock {
    if (!_imageUrlStr.length || !resultBlock) return;
    _image = [SDImageCache.sharedImageCache imageFromCacheForKey:_imageUrlStr];
    if (_image) {
        resultBlock(_image);
        return;
    }
    __weak typeof(self) weakSelf = self;
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:_imageUrlStr] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        weakSelf.image = image;
        [SDImageCache.sharedImageCache storeImage:image forKey:weakSelf.imageUrlStr completion:nil];
        resultBlock(image);
    }];
}

#pragma mark - 获取 ThumbImage
- (void)getThumbImageWithSize:(CGSize)size result:(void (^)(UIImage * _Nullable))resultBlock {
    if (!resultBlock) return;
    if (_thumbImage) {
        resultBlock(_thumbImage);
    } else if (_asset) {
        [self getThumbImageByAssetWithSize:size result:resultBlock];
    } else if (_imageUrlStr.length) {
        [self getThumbImageByUrlWithResult:resultBlock];
    } else if (_image) {
        resultBlock(_image);
    }
}

- (void)getThumbImageByAssetWithSize:(CGSize)size result:(void (^)(UIImage * _Nullable))resultBlock {
    if (!_asset || !resultBlock) return;
    [PHImageManager.defaultManager requestImageForAsset:_asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        if (![info[@"PHImageResultIsDegradedKey"] boolValue]) {
            resultBlock(result);
//        }
    }];
}

- (void)getThumbImageByUrlWithResult:(void (^)(UIImage * _Nullable))resultBlock {
    if (!_thumbSuffix.length) {
        [self getImageByUrlWithResult:resultBlock];
        return;
    }
    if (!_imageUrlStr.length || !resultBlock) return;
    NSString *thumbImageUrlStr = [_imageUrlStr stringByAppendingString:_thumbSuffix];
    _thumbImage = [SDImageCache.sharedImageCache imageFromCacheForKey:thumbImageUrlStr];
    if (_thumbImage) {
        resultBlock(_thumbImage);
        return;
    }
    __weak typeof(self) weakSelf = self;
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:thumbImageUrlStr] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        weakSelf.thumbImage = image;
        [SDImageCache.sharedImageCache storeImage:image forKey:thumbImageUrlStr completion:nil];
        resultBlock(image);
    }];
}

- (UIImage *)thumbImage {
    if (_thumbImage) return _thumbImage;
    if (_imageUrlStr.length && _thumbSuffix.length) {
        _thumbImage = [SDImageCache.sharedImageCache imageFromCacheForKey:[_imageUrlStr stringByAppendingString:_thumbSuffix]];
    }
    return _thumbImage;
}

@end
