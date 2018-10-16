//
//  IMPhotoManager.m
//  IMPhotoBrowser
//
//  Created by 万涛 on 2018/10/10.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoManager.h"
#import "IMPhoto.h"

@interface IMPhotoManager ()

@end

@implementation IMPhotoManager

+ (PHFetchOptions *)assetFetchOptions {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    return options;
}

+ (PHImageRequestOptions *)imageRequestOptions {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = YES;
    options.networkAccessAllowed = YES;
    return options;
}

#pragma mark - 获取所有相册集合
+ (NSArray<NSDictionary *> *)getAllPhotoAlbumArray {
    return [[self getSmartPhotoAlbumArray] arrayByAddingObjectsFromArray:[self getUserPhotoAlbumArray]];
}

#pragma mark - 获取智能相册集合
+ (NSArray<NSDictionary *> *)getSmartPhotoAlbumArray {
    // 智能相册集合【相机胶卷、最近添加、个人收藏、屏幕快照……】
    PHFetchResult<PHAssetCollection *> *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    NSMutableArray<NSDictionary *> *photoAlbumArray = [self getPhotoAlbumArrayWithFetchResult:albums].mutableCopy;
    // 找出“相机胶卷”相册，并提为集合第一个元素
    NSDictionary *cameraRollAlbum;
    for (NSDictionary *albumDict in photoAlbumArray) {
        if (((PHAssetCollection *)(albumDict[IMPBAlbumKey])).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            cameraRollAlbum = albumDict;
            break;
        }
    }
    if (cameraRollAlbum) {
        [photoAlbumArray removeObject:cameraRollAlbum];
        [photoAlbumArray insertObject:cameraRollAlbum atIndex:0];
    }
    return photoAlbumArray.copy;
}

#pragma mark - 获取用户自定义的相册集合
+ (NSArray<NSDictionary *> *)getUserPhotoAlbumArray {
    // 用户自定义的相册集合【iOS设备上创建的相册、第三方App创建、通过iTunes同步的相册……】
    PHFetchResult<PHAssetCollection *> *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    NSArray<NSDictionary *> *photoAlbumArray = [self getPhotoAlbumArrayWithFetchResult:albums];
    return photoAlbumArray;
}

#pragma mark - PHFetchResult → 相册集合
+ (NSArray<NSDictionary *> *)getPhotoAlbumArrayWithFetchResult:(PHFetchResult<PHAssetCollection *> *)fetchResult {
    NSMutableArray<NSDictionary *> *photoAlbumArray = [NSMutableArray array];
    [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult<PHAsset *> *assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:[self assetFetchOptions]];
        if (assetResult.count) {
            NSMutableDictionary *albumDict = [NSMutableDictionary dictionary];
            albumDict[IMPBAlbumKey] = obj;
            albumDict[IMPBAlbumPhotoCountKey] = @(assetResult.count);
            [PHImageManager.defaultManager requestImageForAsset:assetResult.firstObject targetSize:CGSizeMake(40, 40) contentMode:PHImageContentModeAspectFill options:[self imageRequestOptions] resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                albumDict[IMPBAlbumThumbKey] = result;
            }];
            [photoAlbumArray addObject:albumDict];
        }
    }];
    return photoAlbumArray.copy;
}

#pragma mark - 获取相册中的图片集合
+ (NSArray<IMPhoto *> *)getPhotoArrayWithAssetCollection:(PHAssetCollection *)assetCollection {
    if (!assetCollection) return @[];
    PHFetchResult<PHAsset *> *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[self assetFetchOptions]];
    NSMutableArray<IMPhoto *> *assetArray = [NSMutableArray arrayWithCapacity:assetResult.count];
    [assetResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [assetArray addObject:[IMPhoto photoWithAsset:obj]];
    }];
    return assetArray;
}

@end
