//
//  IMPhotosTool.h
//  DaJia
//
//  Created by 万涛 on 2017/11/2.
//  Copyright © 2017年 yeeyuntech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMPhotosTool : NSObject

/** 保存图片到与App同名的相册 */
+ (BOOL)saveImageToAppAlbumWithImage:(UIImage *)image;

@end
