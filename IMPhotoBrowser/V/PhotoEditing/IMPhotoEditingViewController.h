//
//  IMPhotoEditingViewController.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPBStatement.h"
#import "IMPhotoEditingStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoEditingViewController : UIViewController

- (instancetype)initWithPhoto:(IMPhoto *)photo editingStype:(IMPhotoEditingStyle)editingStyle selectEvent:(IMPBPhotoSelectEvent)selectEvent;

@end

NS_ASSUME_NONNULL_END
