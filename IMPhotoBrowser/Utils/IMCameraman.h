//
//  IMCameraman.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^IMCameramanResultBlock)(UIImage *__nullable image);

@interface IMCameraman : NSObject

- (void)takePhotoWithFromVC:(UIViewController *)fromVC result:(IMCameramanResultBlock)result;

@end

NS_ASSUME_NONNULL_END
