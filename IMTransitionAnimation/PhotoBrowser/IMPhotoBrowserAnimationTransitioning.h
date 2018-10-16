//
//  IMPhotoBrowserAnimationTransitioning.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/15.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMBaseAnimationTransitioning.h"
#import "IMPBStatement.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoBrowserAnimationTransitioning : IMBaseAnimationTransitioning

@property (nonatomic, strong) UIView *animSnapshoot;
@property (nonatomic, strong) UIView *animBgView;

/** Present动画起始View(反之：Dismiss动画终点View) */
@property (nonatomic, strong) IMPBAnimationViewBlock orginalViewBlock;

/** Present动画终点View(反之：Dismiss动画起始View) */
@property (nonatomic, strong) IMPBAnimationViewBlock targetViewBlock;

@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
