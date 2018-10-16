//
//  IMPhoto.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMPhoto : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong) UIImage *thumbImage;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) BOOL isTakePhoto;

@property (nonatomic, assign) NSInteger index;

- (void)getImageByAssetWithResult:(void(^)(UIImage *__nullable image))resultBlock;

+ (instancetype)photoWithAsset:(PHAsset *)asset;

+ (instancetype)photoWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
