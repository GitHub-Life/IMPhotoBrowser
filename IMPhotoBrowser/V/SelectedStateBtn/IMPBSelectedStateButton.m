//
//  IMPBSelectedStateButton.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPBSelectedStateButton.h"

@implementation IMPBSelectedStateButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.tintColor = UIColor.clearColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat width_2 = CGRectGetWidth(rect) / 2;
    CGFloat height_2 = CGRectGetHeight(rect) / 2;
    CGFloat radius = MIN(width_2, height_2) / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(width_2, height_2) radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    if (self.selected) {
        [[UIColor colorWithRed:43.f / 255 green:119.f / 255 blue:236.f / 255 alpha:1] setFill];
        [path fill];
        [UIColor.whiteColor setStroke];
        [path setLineWidth:1.f];
        [path stroke];
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(width_2 / 40 * 10 + width_2 / 2, height_2 / 40 * 19 + height_2 / 2)];
        [path addLineToPoint:CGPointMake(width_2 / 40 * 18 + width_2 / 2, height_2 / 40 * 27 + height_2 / 2)];
        [path addLineToPoint:CGPointMake(width_2 / 40 * 32 + width_2 / 2, height_2 / 40 * 13 + height_2 / 2)];
        [UIColor.whiteColor setStroke];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
    } else {
        [[UIColor colorWithWhite:0 alpha:0.33] setFill];
        [UIColor.whiteColor setStroke];
        [path setLineWidth:1.f];
        [path stroke];
    }
}

- (UIColor *)selectedColor {
    if (_selectedColor) return _selectedColor;
    return UIColor.whiteColor;
}

@end
