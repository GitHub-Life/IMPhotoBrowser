//
//  IMPhotoManager.h
//  IMPhotoBrowser
//
//  Created by 万涛 on 2018/10/10.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMPBStatement.h"
@class PHAssetCollection;
@class UIViewController;

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoManager : NSObject

/** 所有相册集合，字典中的数据e格式为："collection":"PHAssetColletion", "thumb":"UIImage - 相册内第一张图片", "count":"NSNumber - 图片数量" */
+ (NSArray<NSDictionary *> *)getAllPhotoAlbumArray;
/** 智能相册集合，字典合适同上⬆️ */
+ (NSArray<NSDictionary *> *)getSmartPhotoAlbumArray;

/**
 获取相册中的相片集合
 @param assetCollection 相册对象
 @return 相片集合
 */
+ (NSArray<IMPhoto *> *)getPhotoArrayWithAssetCollection:(PHAssetCollection *)assetCollection;

/**
 检查相册存取权限
 @param fromVC 未授权时用于弹出UIAlertController的VC(为nil则不弹出)
 @param grantedBlock 授权回调
 */
+ (void)checkPhotoLibraryPermissionsWithFromVC:(UIViewController *)fromVC grantedBlock:(void(^)(void))grantedBlock;

/**
 IMPhoto数组 → UIImage数组
 @param photoArray IMPhoto数组
 @param complete 得到UIImage数组回调
 */
+ (void)imageArrayWithPhotoArray:(NSArray<IMPhoto *> *)photoArray complete:(void(^)(NSArray<UIImage *> *imageArray))complete;

/**
 从photoArray 元素IMPhoto中的PHAsset获取UIImage，获取成功后赋值到IMPhoto中的image属性
 @param photoArray IMPhoto 集合
 @param complete 获取完成
 */
+ (void)getImagesWithPhotoArray:(NSArray<IMPhoto *> *)photoArray complete:(void(^)(void))complete;

/**
 UImage → PHAsset
 @param image UIImage对象
 @param result PHAsset对象
 */
+ (void)getAssetWithImage:(UIImage *)image result:(void(^)(PHAsset *__nullable asset))result;

/**
 相片在系统相册中的locationIdentifier集合 → IMPhoto集合
 @param photoIdentifierArray 相片在系统相册中的locationIdentifier集合
 @return IMPhoto集合
 */
+ (NSArray<IMPhoto *> *)getPhotoArrayWithPhotoIdentifierArray:(NSArray<NSString *> *)photoIdentifierArray;

@end

NS_ASSUME_NONNULL_END
