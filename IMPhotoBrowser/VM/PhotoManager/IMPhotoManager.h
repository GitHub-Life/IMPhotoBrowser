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
+ (void)checkPhotoLibraryPermissionsWithFromVC:(UIViewController *)fromVC GrantedBlock:(void(^)(void))grantedBlock;

+ (void)imageArrayWithPhotoArray:(NSArray<IMPhoto *> *)photoArray complete:(void(^)(NSArray<UIImage *> *imageArray))complete;

@end

NS_ASSUME_NONNULL_END
