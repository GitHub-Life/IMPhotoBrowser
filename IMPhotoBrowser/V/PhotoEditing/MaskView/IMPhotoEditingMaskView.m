//
//  IMPhotoEditingMaskView.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/11/9.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoEditingMaskView.h"

@implementation IMPhotoEditingMaskView

- (instancetype)initWithEditingStyle:(IMPhotoEditingStyle)editingStyle frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        CGFloat width_2 = CGRectGetWidth(frame) / 2;
        CGFloat height_2 = CGRectGetHeight(frame) / 2;
        CGFloat length_2 = MIN(width_2, height_2) - 10;
        _clipRect = CGRectMake(width_2 - length_2, height_2 - length_2, length_2 * 2, length_2 * 2);
        _clipRectMargin = UIEdgeInsetsMake(CGRectGetMinY(_clipRect), CGRectGetMinX(_clipRect), CGRectGetHeight(frame) - CGRectGetMaxY(_clipRect), CGRectGetWidth(frame) - CGRectGetMaxX(_clipRect));
        
        UIBezierPath *centerPath;
        if (editingStyle == IMPhotoEditingStyleCircle) {
            centerPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(_clipRect), CGRectGetMidY(_clipRect)) radius:length_2 startAngle:0 endAngle:(2 * M_PI) clockwise:YES];
        } else {
            centerPath = [UIBezierPath bezierPathWithRect:_clipRect];
        }
        CAShapeLayer *centerLayer = [CAShapeLayer layer];
        [centerLayer setStrokeColor:UIColor.whiteColor.CGColor];
        [centerLayer setLineWidth:2.f];
        centerLayer.path = centerPath.CGPath;
        [self.layer addSublayer:centerLayer];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
        [path appendPath:centerPath];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = path.CGPath;
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        self.layer.mask = maskLayer;
    }
    return self;
}

@end
