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
@property (nonatomic, assign) BOOL roundAvatar;

@property (nonatomic, strong) IMPBAnimationViewBlock originalViewBlock;

@property (nonatomic, strong) IMPBAnimationViewBlock targetViewBlock;

@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
