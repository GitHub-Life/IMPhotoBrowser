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
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat radius = MIN(width, height) / 2 / 2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(width / 2, height / 2) radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [[UIColor colorWithWhite:0 alpha:0.33] setFill];
    [path fill];
    [UIColor.whiteColor setStroke];
    CGContextSetLineWidth(context, 1.f);
    [path stroke];
    
    if (self.selected) {
        path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(width / 2, height / 2) radius:radius / 2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
        [self.selectedColor setFill];
        [path fill];
    }
}

- (UIColor *)selectedColor {
    if (_selectedColor) return _selectedColor;
    return UIColor.whiteColor;
}

@end
