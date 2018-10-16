//
//  IMPhotoBrowserAnimationTransitioning.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/15.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoBrowserAnimationTransitioning.h"

@interface IMPhotoBrowserAnimationTransitioning ()

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat animPercent;

@property (nonatomic, weak) UIView *originalView;

@end

@implementation IMPhotoBrowserAnimationTransitioning

#pragma mark - present 动画
- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    toVC.view.alpha = 0.f;
    toVC.view.frame = containerView.bounds;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.alpha = 1.f;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - dismiss 动画
- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIView *containerView = [transitionContext containerView];
    
    CGRect originalFrame = [self.originalViewRectBlock(_currentIndex) CGRectValue];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.alpha = 0.f;
        if (CGRectIsEmpty(originalFrame)) {
            CGAffineTransform transform = self.animSnapshoot.transform;
            self.animSnapshoot.transform = CGAffineTransformMake(0.1f, transform.b, transform.c, 0.1f, transform.tx, transform.ty);
            self.animSnapshoot.alpha = 0.f;
        } else {
            self.animSnapshoot.frame = originalFrame;
        }
        self.animBgView.alpha = 0.f;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [transitionContext completeTransition:YES];
            [self.animSnapshoot removeFromSuperview];
            [self.animBgView removeFromSuperview];
            self.originalView.hidden = NO;
        }
    }];
}

#pragma mark - 手势响应事件
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGr {
    switch (panGr.state) {
        case UIGestureRecognizerStateBegan: {
            UIView *animView = self.targetViewBlock(0);
            if (!animView) return;
            UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
            _animBgView = [[UIView alloc] initWithFrame:keyWindow.bounds];
            _animBgView.backgroundColor = self.dismissVC.view.backgroundColor;
            [keyWindow addSubview:_animBgView];
            _animSnapshoot = [animView snapshotViewAfterScreenUpdates:NO];
            _animSnapshoot.frame = [animView convertRect:animView.bounds toView:keyWindow];
            [keyWindow addSubview:_animSnapshoot];
            self.dismissVC.view.hidden = YES;
            _startPoint = [panGr locationInView:panGr.view];
            self.originalView = self.originalViewBlock(self.currentIndex);
            self.originalView.hidden = YES;
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [panGr translationInView:panGr.view];
            if (translation.y > 0) {
                _animPercent = 1 - translation.y / (CGRectGetHeight(UIScreen.mainScreen.bounds) -  _startPoint.y);
            } else {
                _animPercent = 1 + translation.y /  _startPoint.y;
            }
            _animBgView.alpha = _animPercent;
            if (_animPercent < 0.3f) _animPercent = 0.3f;
            _animSnapshoot.transform = CGAffineTransformMake(_animPercent, 0, 0, _animPercent, translation.x, translation.y);
        } break;
        case UIGestureRecognizerStateEnded: {
            if (_animPercent < 0.5f) {
                [self.dismissVC dismissViewControllerAnimated:YES completion:nil];
            } else {
                [UIView animateWithDuration:0.3f animations:^{
                    self.animSnapshoot.transform = CGAffineTransformIdentity;
                    self.animBgView.alpha = 1.f;
                } completion:^(BOOL finished) {
                    self.originalView.hidden = NO;
                    self.dismissVC.view.hidden = NO;
                    [self.animSnapshoot removeFromSuperview];
                    [self.animBgView removeFromSuperview];
                }];
            }
        } break;
        default:
            break;
    }
}

#pragma mark - Getter
- (IMPBAnimationViewBlock)targetViewBlock {
    if (!_targetViewBlock) {
        _targetViewBlock = ^UIView *(NSInteger index){
            return nil;
        };
    }
    return _targetViewBlock;
}

- (IMPBAnimationRectBlock)originalViewRectBlock {
    if (!_originalViewRectBlock) {
        _originalViewRectBlock = ^NSValue *(NSInteger index){
            return [NSValue valueWithCGRect:CGRectZero];
        };
    }
    return _originalViewRectBlock;
}

- (IMPBAnimationViewBlock)originalViewBlock {
    if (!_originalViewBlock) {
        _originalViewBlock = ^UIView *(NSInteger index){
            return nil;
        };
    }
    return _originalViewBlock;
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (![gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) return NO;
    CGPoint translation = [((UIPanGestureRecognizer *)gestureRecognizer) translationInView:gestureRecognizer.view];
    return fabs(translation.y) > fabs(translation.x);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

@end
