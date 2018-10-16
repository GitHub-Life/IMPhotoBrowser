//
//  IMPresentListAnimationTransitioning.m
//  CommentUIDemo
//
//  Created by 万涛 on 2018/8/28.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMPresentListAnimationTransitioning.h"

@interface IMPresentListAnimationTransitioning ()

@property (nonatomic, assign) CGFloat startTranslationY;

@end

@implementation IMPresentListAnimationTransitioning

//#pragma mark - UIViewControllerAnimatedTransitioning
//- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
//    return 5;
//}

#pragma mark - present 动画
- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *presentingSnapshot = [fromVC.view snapshotViewAfterScreenUpdates:YES];
    presentingSnapshot.tag = 100;
    presentingSnapshot.frame = fromVC.view.frame;
    fromVC.view.hidden = YES;
    [containerView addSubview:presentingSnapshot];
    
    UIView *maskView = [[UIView alloc] initWithFrame:containerView.bounds];
    maskView.tag = 200;
    [maskView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    maskView.alpha = 0;
    [containerView addSubview:maskView];
    
    [containerView addSubview:toVC.view];
    toVC.view.frame = containerView.bounds;
    toVC.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(toVC.view.bounds));
    if (self.topOffset > 0 && self.cornerRadius > 0) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:toVC.view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = CGRectMake(0, self.topOffset, CGRectGetWidth(toVC.view.bounds), CGRectGetHeight(toVC.view.bounds) - self.topOffset);
        maskLayer.path = maskPath.CGPath;
        toVC.view.layer.mask = maskLayer;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.transform = CGAffineTransformIdentity;
        maskView.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - dismiss 动画
- (void)dismissAnimateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *maskView;
    UIView *presentingSnapshot;
    for (UIView *subV in [transitionContext containerView].subviews) {
        if (subV.tag == 100) {
            presentingSnapshot = subV;
        } else if (subV.tag == 200) {
            maskView = subV;
        }
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        maskView.alpha = 0;
        if (weakSelf.direction == IMTransitionDirectionVertical) {
            fromVC.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(toVC.view.bounds));
        } else {
            fromVC.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(toVC.view.bounds), 0);
        }
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [transitionContext completeTransition:YES];
            toVC.view.frame = presentingSnapshot.frame;
            toVC.view.hidden = NO;
            [maskView removeFromSuperview];
            [presentingSnapshot removeFromSuperview];
        }
    }];
}

#pragma mark - 手势
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGr {
    CGPoint velocity = [panGr velocityInView:panGr.view];
    if (panGr.state == UIGestureRecognizerStateBegan) {
        if (fabs(velocity.x) > fabs(velocity.y)) {
            self.direction = IMTransitionDirectionHorizontal;
        } else {
            self.direction = IMTransitionDirectionVertical;
        }
    }
    if (self.direction == IMTransitionDirectionHorizontal) {
        CGFloat percent = [panGr translationInView:panGr.view].x / UIScreen.mainScreen.bounds.size.width;
        switch (panGr.state) {
            case UIGestureRecognizerStateBegan: {
                [self updateTransitionPercent:percent state:IMTransitionPercentStateBegin];
            } break;
            case UIGestureRecognizerStateChanged: {
                [self updateTransitionPercent:percent state:IMTransitionPercentStateChanged];
            } break;
            case UIGestureRecognizerStateEnded: {
                [self updateTransitionPercent:percent state:IMTransitionPercentStateEnded];
            } break;
            default:
                break;
        }
    } else if ([panGr.view isKindOfClass:UIScrollView.class]) {
        UIScrollView *scrollView = (UIScrollView *)panGr.view;
        if (scrollView.contentOffset.y > self.dismissScrollThreshold) {
            if (panGr.state == UIGestureRecognizerStateEnded && self.interactive) {
                [self updateTransitionPercent:0 state:IMTransitionPercentStateEnded];
                _startTranslationY = 0;
            }
            return;
        }
        CGFloat transitionY = [panGr translationInView:panGr.view].y;
        if (transitionY <= 0 && panGr.state == UIGestureRecognizerStateBegan) {
            return;
        }
        if (_startTranslationY == 0) {
            _startTranslationY = transitionY;
        }
        CGFloat percent = (transitionY - _startTranslationY) / UIScreen.mainScreen.bounds.size.height;
        switch (panGr.state) {
            case UIGestureRecognizerStateBegan:/* {
                [self updateTransitionPercent:percent state:IMTransitionPercentStateBegin];
            } break;*/
            case UIGestureRecognizerStateChanged: {
                [self updateTransitionPercent:percent state:IMTransitionPercentStateChanged];
            } break;
            case UIGestureRecognizerStateEnded: {
                [self updateTransitionPercent:percent state:IMTransitionPercentStateEnded];
                _startTranslationY = 0;
            } break;
            default:
                break;
        }
    } else {
        CGFloat percent = [panGr translationInView:panGr.view].y / UIScreen.mainScreen.bounds.size.height * 2;
        switch (panGr.state) {
            case UIGestureRecognizerStateBegan: {
                [self updateTransitionPercent:percent state:IMTransitionPercentStateBegin];
            } break;
            case UIGestureRecognizerStateChanged: {
                [self updateTransitionPercent:percent state:IMTransitionPercentStateChanged];
            } break;
            case UIGestureRecognizerStateEnded: {
                [self updateTransitionPercent:percent state:IMTransitionPercentStateEnded];
            } break;
            default:
                break;
        }
    }
}


#pragma mark - UIGesture Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        UIPanGestureRecognizer *panGr = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGr translationInView:panGr.view];
        if (fabs(translation.x) < fabs(translation.y)) {
            return self.scrollView.contentOffset.y <= self.dismissScrollThreshold;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
