//
//  IMPhotoEditingMaskView.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoEditingMaskView.h"

@interface IMPhotoEditingMaskView ()

@property (nonatomic, assign) CGRect arrowRect;

@property (nonatomic, assign) CGFloat beforeTranslationY;

@end

@implementation IMPhotoEditingMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        
        CGRect clipRect = self.clipRect;
        _arrowRect = CGRectMake((CGRectGetMaxX(clipRect) - 40.f),(CGRectGetMidY(clipRect) - 20.f), 40.f, 40.f);
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGrEvent:)]];
    }
    return self;
}

- (void)panGrEvent:(UIPanGestureRecognizer *)panGr {
    CGFloat translationY = [panGr translationInView:panGr.view].y;
    switch (panGr.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            CGFloat offsetY = translationY - _beforeTranslationY;
            if (CGRectGetMinY(self.clipRect) + offsetY < 0) {
                offsetY = -CGRectGetMinY(self.clipRect);
            } else if (CGRectGetMaxY(self.clipRect) + offsetY > CGRectGetHeight(self.bounds)) {
                offsetY = CGRectGetHeight(self.bounds) - CGRectGetMaxY(self.clipRect);
            }
            _offsetY += offsetY;
            _arrowRect.origin.y += offsetY;
            _beforeTranslationY = translationY;
            [self setNeedsDisplay];
        } break;
        case UIGestureRecognizerStateEnded: {
            _beforeTranslationY = 0.f;
        } break;
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat maskUnilateralHeight = (height - width) / 2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0 alpha:0.33f] setFill];
    CGContextFillRect(context, CGRectMake(0, 0, width, maskUnilateralHeight + _offsetY));
    CGContextFillRect(context, CGRectMake(0, maskUnilateralHeight + width + _offsetY, width, maskUnilateralHeight - _offsetY));
    
    [UIColor.whiteColor setStroke];
    CGContextSetLineWidth(context, 1.f);
    CGContextStrokeRect(context, CGRectMake(0.5f, maskUnilateralHeight + _offsetY + 0.5f, width - 1.f, width - 1.f));
    
    if (!_hideArrow) {
        // 画移动箭头
        CGFloat arrowSize_8 = CGRectGetWidth(_arrowRect) / 8;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [[UIColor colorWithWhite:0 alpha:0.1f] setFill];
        [path addArcWithCenter:CGPointMake(CGRectGetMidX(_arrowRect), CGRectGetMidY(_arrowRect)) radius:arrowSize_8 * 4 startAngle:0 endAngle:2 * M_PI clockwise:YES];
        [path fill];
        
        path = [UIBezierPath bezierPath];
        [[UIColor colorWithWhite:1 alpha:0.5f] setFill];
        [path moveToPoint:CGPointMake(CGRectGetMinX(_arrowRect) + arrowSize_8 * 2, CGRectGetMinY(_arrowRect) + arrowSize_8 * 3)];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(_arrowRect) + arrowSize_8 * 4, CGRectGetMinY(_arrowRect) + arrowSize_8 * 1)];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(_arrowRect) + arrowSize_8 * 6, CGRectGetMinY(_arrowRect) + arrowSize_8 * 3)];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(_arrowRect) + arrowSize_8 * 5, CGRectGetMinY(_arrowRect) + arrowSize_8 * 3)];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(_arrowRect) + arrowSize_8 * 5, CGRectGetMinY(_arrowRect) + arrowSize_8 * 5)];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(_arrowRect) + arrowSize_8 * 6, CGRectGetMinY(_arrowRect) + arrowSize_8 * 5)];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(_arrowRect) + arrowSize_8 * 4, CGRectGetMinY(_arrowRect) + arrowSize_8 * 7)];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(_arrowRect) + arrowSize_8 * 2, CGRectGetMinY(_arrowRect) + arrowSize_8 * 5)];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(_arrowRect) + arrowSize_8 * 3, CGRectGetMinY(_arrowRect) + arrowSize_8 * 5)];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(_arrowRect) + arrowSize_8 * 3, CGRectGetMinY(_arrowRect) + arrowSize_8 * 3)];
        [path closePath];
        [path fill];
    }
}

- (void)setHideArrow:(BOOL)hideArrow {
    _hideArrow = hideArrow;
    [self setNeedsDisplay];
}

- (CGRect)clipRect {
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    return CGRectMake(0, (height - width) / 2 + _offsetY, width, width);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(_arrowRect, point)) {
        return view;
    }
    return nil;
}

@end
