//
//  IMPhotoEditingMaskView.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoEditingMaskView.h"

@implementation IMPhotoEditingMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        self.userInteractionEnabled = NO;
    }
    return self;
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
    CGContextStrokeRect(context, CGRectMake(0.5f, maskUnilateralHeight + _offsetY - 0.5f, width - 1.f, width - 1.f));
}

- (void)setOffsetY:(CGFloat)offsetY {
    _offsetY = offsetY;
    [self setNeedsDisplay];
}

- (CGRect)clipRect {
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    return CGRectMake(0, (height - width) / 2 + _offsetY, width, width);
}

@end
