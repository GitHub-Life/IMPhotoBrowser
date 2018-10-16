//
//  IMBaseAnimationTransitioning.m
//  TransitionAnimationDemo
//
//  Created by 万涛 on 2018/6/20.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMBaseAnimationTransitioning.h"

#define DefaultPercentThreshold 0.3

@implementation IMBaseAnimationTransitioning

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.transitionType) {
        case IMTransitionTypePresent: {
            [self presentAnimateTransition:transitionContext];
        } break;
        case IMTransitionTypeDismiss: {
            [self dismissAnimateTransition:transitionContext];
        } break;
    }
}

/** present动画 【需要子类实现】 */
- (void)presentAnimateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    @throw [NSException exceptionWithName:@"Unimplemented Methods" reason:[NSString stringWithFormat:@"The \"%@\" method has not yet been implemented in \"%@\"", NSStringFromSelector(_cmd), NSStringFromClass(self.class)] userInfo:nil];
}
/** dismiss动画 【需要子类实现】 */
- (void)dismissAnimateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    @throw [NSException exceptionWithName:@"Unimplemented Methods" reason:[NSString stringWithFormat:@"The \"%@\" method has not yet been implemented in \"%@\"", NSStringFromSelector(_cmd), NSStringFromClass(self.class)] userInfo:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.transitionType = IMTransitionTypePresent;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transitionType = IMTransitionTypeDismiss;
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.interactive ? self : nil;
}

#pragma mark - 添加手势
- (UIPanGestureRecognizer *)addPanGerstureForTargetView:(UIView *)targetView dismissVC:(UIViewController *)dismissVC {
    self.dismissVC = dismissVC;
    UIPanGestureRecognizer *panGr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGr.delegate = self;
    [targetView addGestureRecognizer:panGr];
    return panGr;
}

- (void)updateTransitionPercent:(CGFloat)percent state:(IMTransitionPercentState)state {
    if (percent < 0) percent = 0;
    if (percent > 1) percent = 1;
    switch (state) {
        case IMTransitionPercentStateBegin:
        case IMTransitionPercentStateChanged: {
            if (!self.interactive) {
                self.interactive = YES;
                [self.dismissVC dismissViewControllerAnimated:YES completion:nil];
            }
            [self updateInteractiveTransition:percent];
        } break;
        case IMTransitionPercentStateEnded: {
            self.interactive = NO;
            if (percent > self.percentThreshold) {
                self.completionSpeed = 1 - percent;
                [self finishInteractiveTransition];
            } else {
                self.completionSpeed = percent;
                [self cancelInteractiveTransition];
            }
        } break;
        default:
            break;
    }
}

- (CGFloat)percentThreshold {
    if (_percentThreshold <= 0) {
        _percentThreshold = DefaultPercentThreshold;
    }
    if (_percentThreshold > 1) {
        _percentThreshold = DefaultPercentThreshold;
    }
    return _percentThreshold;
}

/** 手势回调 【需要子类实现】 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGr {
    @throw [NSException exceptionWithName:@"Unimplemented Methods" reason:[NSString stringWithFormat:@"The \"%@\" method has not yet been implemented in \"%@\"", NSStringFromSelector(_cmd), NSStringFromClass(self.class)] userInfo:nil];
}

- (void)setDismissScrollThreshold:(CGFloat)dismissScrollThreshold {
    if (!_setedDismissScrollThreshold) {
        _setedDismissScrollThreshold = YES;
        _dismissScrollThreshold = dismissScrollThreshold;
    }
}

@end
