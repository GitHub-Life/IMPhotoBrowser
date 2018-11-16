//
//  IMPhotoEditingViewController_Deprecated.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPBStatement.h"
#import "IMPhotoBrowserAnimationTransitioning.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoEditingViewController_Deprecated : UIViewController

- (instancetype)initWithPhoto:(IMPhoto *)photo browseFinish:(IMPBPhotoBrowseFinishEvent)browseFinish;

@property (nonatomic, strong) IMPhotoBrowserAnimationTransitioning *animationTransitioning;

@end

NS_ASSUME_NONNULL_END
