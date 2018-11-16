//
//  IMPhotoManager.m
//  IMPhotoBrowser
//
//  Created by 万涛 on 2018/10/10.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoManager.h"

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
        IMPhoto *photo = [IMPhoto photoWithAsset:obj];
        photo.index = idx;
        [assetArray addObject:photo];
    }];
    return assetArray;
}

#pragma mark - 检查相册存取权限
+ (void)checkPhotoLibraryPermissionsWithFromVC:(UIViewController *)fromVC grantedBlock:(void(^)(void))grantedBlock {
    switch (PHPhotoLibrary.authorizationStatus) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    if (grantedBlock) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            // 这里延时，是因为界面上还有些任务尚未完成，不能立即跳转页面，否则会报 “waitUntilAllTasksAreFinished” 异常
                            grantedBlock();
                        });
                    }
                }
            }];
        } break;
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted: {
            if (fromVC) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"无法读取相册，请检查相册访问权限" preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }]];
                [fromVC presentViewController:alertC animated:YES completion:nil];
            }
        } break;
        case PHAuthorizationStatusAuthorized: {
            if (grantedBlock) {
                grantedBlock();
            }
        } break;
    }
}

#pragma mark - IMPhoto数组 → UIImage数组
+ (void)imageArrayWithPhotoArray:(NSArray<IMPhoto *> *)photoArray complete:(nonnull void (^)(NSArray<UIImage *> * _Nonnull))complete {
    if (!complete) return;
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:photoArray.count];
    for (IMPhoto *photo in photoArray) {
        [photo getImageWithResult:^(UIImage * _Nullable image) {
            tempDict[photo.asset.localIdentifier] = image;
            if (tempDict.count >= photoArray.count) {
                NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:photoArray.count];
                for (IMPhoto *p in photoArray) {
                    [imageArray addObject:tempDict[p.asset.localIdentifier]];
                }
                complete(imageArray.copy);
            }
        }];
    }
}

#pragma mark - 从photoArray 元素IMPhoto中的PHAsset获取UIImage，获取成功后赋值到IMPhoto中的image属性
+ (void)getImagesWithPhotoArray:(NSArray<IMPhoto *> *)photoArray complete:(void (^)(void))complete {
    if (!complete) return;
    if (!photoArray.count) {
        complete();
    }
    __block NSInteger count = 0;
    NSInteger totalCount = photoArray.count;
    for (IMPhoto *photo in photoArray) {
        [photo getImageWithResult:^(UIImage * _Nullable image) {
            photo.image = image;
            count += 1;
            if (count >= totalCount) {
                complete();
            }
        }];
    }
}

#pragma mark - UIImage → PHAsset
+ (void)getAssetWithImage:(UIImage *)image result:(nonnull void (^)(PHAsset * _Nullable))result {
    if (!image || !result) return;
    __block NSString *localIdentifier;
    [PHPhotoLibrary.sharedPhotoLibrary performChanges:^{
        localIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                result([self getPhotoArrayWithPhotoIdentifierArray:@[localIdentifier]].firstObject.asset);
            } else {
                result(nil);
            }
        });
    }];
}

#pragma mark - 相片在系统相册中的locationIdentifier集合 → IMPhoto集合
+ (NSArray<IMPhoto *> *)getPhotoArrayWithPhotoIdentifierArray:(NSArray<NSString *> *)photoIdentifierArray {
    if (!photoIdentifierArray.count) return nil;
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:photoIdentifierArray options:nil];
    NSMutableArray *photoArray = [NSMutableArray arrayWithCapacity:result.count];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [photoArray addObject:[IMPhoto photoWithAsset:obj]];
    }];
    return photoArray.copy;
}

@end
