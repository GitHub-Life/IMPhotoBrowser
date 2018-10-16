//
//  IMPhotoPickerContainerViewController.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPBStatement.h"
@class IMPhoto;

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoPickerContainerViewController : UIViewController

- (instancetype)initWithChoosePhotoMaxCount:(NSInteger)maxCount selectEvent:(IMPBPhotoArraySelectEvent)selectEvent;

- (UINavigationController *)naviVC;

@end

NS_ASSUME_NONNULL_END
