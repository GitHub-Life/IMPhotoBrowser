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

@end

@implementation IMPhotoBrowserAnimationTransitioning

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
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *presentingSnapshot = [containerView viewWithTag:100];
    UIView *originalView = self.orginalViewBlock(_currentIndex);
    CGRect originalFrame = [originalView convertRect:originalView.bounds toView:containerView];
    if (originalView.tag == IMPBTailViewTag) {
        originalFrame = CGRectMake(CGRectGetWidth(containerView.bounds), CGRectGetHeight(containerView.bounds), 0, 0);
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.alpha = 0.f;
        weakSelf.animSnapshoot.frame = originalFrame;
        weakSelf.animBgView.alpha = 0.f;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [transitionContext completeTransition:YES];
            toVC.view.hidden = NO;
            [presentingSnapshot removeFromSuperview];
            [weakSelf.animSnapshoot removeFromSuperview];
            [weakSelf.animBgView removeFromSuperview];
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

- (IMPBAnimationViewBlock)orginalViewBlock {
    if (!_orginalViewBlock) {
        _orginalViewBlock = ^UIView *(NSInteger index){
            return nil;
        };
    }
    return _orginalViewBlock;
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
