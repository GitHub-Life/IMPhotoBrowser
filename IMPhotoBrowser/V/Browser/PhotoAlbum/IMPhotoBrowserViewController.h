//
//  IMPhotoBrowserViewController.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/13.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPBStatement.h"
#import "IMPhotoBrowserAnimationTransitioning.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) IMPhotoBrowserAnimationTransitioning *animationTransitioning;

- (instancetype)initWithPhotoArray:(NSArray<IMPhoto *> *)photoArray currentIndex:(NSInteger)currentIndex maxCount:(NSInteger)maxCount;

@property (nonatomic, strong) IMPBPhotoBrowseFinishEvent browseFinish;
@property (nonatomic, strong) IMPBPhotoSelectEvent photoSelectEvent;

@end

NS_ASSUME_NONNULL_END
