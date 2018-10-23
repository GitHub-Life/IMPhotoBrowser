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

/** 在集合中的索引值 */
@property (nonatomic, assign) NSInteger index;
/** 是否已选中 */
@property (nonatomic, assign) BOOL selected;
/** 是否已保存 */
@property (nonatomic, assign) BOOL saved;

+ (instancetype)photoWithAsset:(PHAsset *)asset;
+ (instancetype)photoWithImage:(UIImage *)image;
+ (instancetype)photoWithImageUrlStr:(NSString *)imageUrlStr;
+ (instancetype)photoWithImageUrlStr:(NSString *)imageUrlStr thumbSuffix:(NSString *)thumbSuffix;

/** 是否是拍照而来 */
@property (nonatomic, assign) BOOL isTakePhoto;
/** 相片对象 */
@property (nonatomic, strong) PHAsset *asset;

/** 图片网络URL */
@property (nonatomic, copy) NSString *imageUrlStr;
/** 缩略图网络URL后缀 */
@property (nonatomic, copy) NSString *thumbSuffix;

/** 缩略图 */
@property (nonatomic, strong) UIImage *thumbImage;
/** 图片 */
@property (nonatomic, strong) UIImage *image;

- (void)getImageWithResult:(void(^)(UIImage *__nullable image))resultBlock;

@end

NS_ASSUME_NONNULL_END
