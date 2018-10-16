//
//  IMPresentListAnimationTransitioning.h
//  CommentUIDemo
//
//  Created by 万涛 on 2018/8/28.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMBaseAnimationTransitioning.h"

@interface IMPresentListAnimationTransitioning : IMBaseAnimationTransitioning

/** present出的VC.view顶部的偏移量 */
@property (nonatomic, assign) CGFloat topOffset;
/** present出的VC.view顶部左右的圆角半径 */
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) IMTransitionDirection direction;

@property (nonatomic, weak) UIScrollView *scrollView;

@end
