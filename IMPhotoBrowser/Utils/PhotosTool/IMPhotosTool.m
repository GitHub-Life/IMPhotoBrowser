//
//  IMPhotosTool.m
//  DaJia
//
//  Created by 万涛 on 2017/11/2.
//  Copyright © 2017年 yeeyuntech. All rights reserved.
//

#import "IMPhotosTool.h"
#import <Photos/Photos.h>

@implementation IMPhotosTool
/**
 *  获得刚才添加到【相机胶卷】中的图片
 */
+ (PHFetchResult<PHAsset *> *)createdAssetWithImage:(UIImage *)image {
    __block NSString *createdAssetId = nil;
    // 添加图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    if (!createdAssetId) {
        return nil;
    }
    // 在保存完毕后取出图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
}

/**
 *  获得【自定义相册】
 */
+ (PHAssetCollection *)createdCollection {
    // 获取软件的名字作为相册的标题
    NSString *title = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    // 代码执行到这里，说明还没有自定义相册
    __block NSString *createdCollectionId = nil;
    // 创建一个新的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    if (!createdCollectionId) {
        return nil;
    }
    // 创建完毕后再取出相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
}

/**
 *  保存图片到相册
 */
+ (BOOL)saveImageToAppAlbumWithImage:(UIImage *)image {
    // 获得相片
    PHFetchResult<PHAsset *> *createdAssets = [self createdAssetWithImage:image];
    // 获得相册
    PHAssetCollection *createdCollection = [self createdCollection];
    if (!createdAssets || !createdCollection) {
        return NO;
    }
    // 将相片添加到相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    // 保存结果
    if (error) {
        return NO;
    } else {
        return YES;
    }
}

@end
