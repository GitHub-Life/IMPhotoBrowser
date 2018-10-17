//
//  UIViewController+IMTakePhoto.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^IMTakePhotoResultBlock)(UIImage *__nullable image);

@interface UIViewController (IMTakePhoto) <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)takePhotoWithResult:(IMTakePhotoResultBlock)result;
@property (nonatomic, strong) IMTakePhotoResultBlock resultBlock;

@end

NS_ASSUME_NONNULL_END
