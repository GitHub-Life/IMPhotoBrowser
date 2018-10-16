//
//  IMBaseAnimationTransitioning.h
//  TransitionAnimationDemo
//
//  Created by 万涛 on 2018/6/20.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IMTransitionType) {
    IMTransitionTypePresent = 0,
    IMTransitionTypeDismiss
};

typedef NS_ENUM(NSInteger, IMTransitionPercentState) {
    IMTransitionPercentStateBegin = 0,
    IMTransitionPercentStateChanged,
    IMTransitionPercentStateEnded,
};

typedef NS_ENUM(NSInteger, IMTransitionDirection) {
    IMTransitionDirectionVertical = 0,
    IMTransitionDirectionHorizontal
};

@protocol IMAnimationTransitioningDelegate

/** present动画【需要子类实现】 */
- (void)presentAnimateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext;
/** dismiss动画【需要子类实现】 */
- (void)dismissAnimateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext;

@optional
/** 手势回调【需要子类实现】 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGr;

@end

@interface IMBaseAnimationTransitioning : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate, IMAnimationTransitioningDelegate>

/** 转场动画类型 Present / Dismiss */
@property (nonatomic, assign) IMTransitionType transitionType;

/** 手势dismiss的ViewController */
@property (nonatomic, weak) UIViewController *dismissVC;
/** 是否开始响应转场动画手势 */
@property (nonatomic, assign) BOOL interactive;
/** 转场动画百分比阈值(即转场动画结束时，百分比超过此值，则完成转场动画，否则恢复到转场动画开始前的效果)【默认值:0.3】 */
@property (nonatomic, assign) CGFloat percentThreshold;
/**
 添加手势
 @param targetView 需要响应手势deView
 @param dismissVC 手势dismiss的ViewController
 */
- (UIPanGestureRecognizer *)addPanGerstureForTargetView:(UIView *)targetView dismissVC:(UIViewController *)dismissVC;
/**
 更新过渡的百分比
 @param percent 百分比
 @param state 状态
 */
- (void)updateTransitionPercent:(CGFloat)percent state:(IMTransitionPercentState)state;

/** <#注释#> */
@property (nonatomic, assign) CGFloat dismissScrollThreshold;
@property (nonatomic, assign) BOOL setedDismissScrollThreshold;

@end
