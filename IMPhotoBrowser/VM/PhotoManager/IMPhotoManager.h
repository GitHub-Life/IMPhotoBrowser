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
@class IMPhoto;

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoManager : NSObject

/** 所有相册集合，字典中的数据e格式为："collection":"PHAssetColletion", "thumb":"UIImage - 相册内第一张图片", "count":"NSNumber - 图片数量" */
+ (NSArray<NSDictionary *> *)getAllPhotoAlbumArray;
/** 智能相册集合，字典合适同上⬆️ */
+ (NSArray<NSDictionary *> *)getSmartPhotoAlbumArray;

/** 获取相册中的图片集合 */
+ (NSArray<IMPhoto *> *)getPhotoArrayWithAssetCollection:(PHAssetCollection *)assetCollection;

@end

NS_ASSUME_NONNULL_END
