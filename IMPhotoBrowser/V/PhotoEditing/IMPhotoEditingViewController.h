//
//  IMPhotoEditingViewController.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPBStatement.h"
#import "IMPhotoBrowserAnimationTransitioning.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoEditingViewController : UIViewController

- (instancetype)initWithPhoto:(IMPhoto *)photo browseFinish:(IMPBPhotoBrowseFinishEvent)browseFinish;

@property (nonatomic, strong) IMPhotoBrowserAnimationTransitioning *animationTransitioning;
@property (nonatomic, strong) IMPBAnimationViewBlock originalViewBlock;

@end

NS_ASSUME_NONNULL_END
