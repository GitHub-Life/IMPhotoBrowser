//
//  IMNetworkPhotoBrowserViewController.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPhotoBrowserAnimationTransitioning.h"
#import "IMPhotoBrowserParameter.h"
@class IMPhoto;

NS_ASSUME_NONNULL_BEGIN

@interface IMNetworkPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) IMPhotoBrowserAnimationTransitioning *animationTransitioning;

- (instancetype)initWithPhotoArray:(NSArray<IMPhoto *> *)photoArray currentIndex:(NSInteger)currentIndex;

+ (void)browserPhotoWithParameter:(IMPhotoBrowserParameter *)parameter;

@end

NS_ASSUME_NONNULL_END
