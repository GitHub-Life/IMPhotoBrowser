//
//  IMPBXButton.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/15.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPBXButton.h"

@implementation IMPBXButton

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat width_2 = CGRectGetWidth(rect) / 2;
    CGFloat height_2 = CGRectGetHeight(rect) / 2;
    CGFloat drawAreaW_2 = _xRedius > 0 ? _xRedius : 8.f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width_2 - drawAreaW_2, height_2 - drawAreaW_2)];
    [path addLineToPoint:CGPointMake(width_2 + drawAreaW_2, height_2 + drawAreaW_2)];
    [path moveToPoint:CGPointMake(width_2 - drawAreaW_2,  height_2 + drawAreaW_2)];
    [path addLineToPoint:CGPointMake(width_2 + drawAreaW_2, height_2 - drawAreaW_2)];
    [(self.tintColor ?: UIColor.blackColor) setStroke];
    [path stroke];
}

- (void)setXRedius:(CGFloat)xRedius {
    _xRedius = xRedius;
    [self setNeedsDisplay];
}

@end
