//
//  IMPBCloseButton.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/15.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPBCloseButton.h"

@implementation IMPBCloseButton

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat width_2 = CGRectGetWidth(rect) / 2;
    CGFloat height_2 = CGRectGetHeight(rect) / 2;
    CGFloat drawAreaW_2 = 16.f / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width_2 - drawAreaW_2, height_2 - drawAreaW_2)];
    [path addLineToPoint:CGPointMake(width_2 + drawAreaW_2, height_2 + drawAreaW_2)];
    [path moveToPoint:CGPointMake(width_2 - drawAreaW_2,  height_2 + drawAreaW_2)];
    [path addLineToPoint:CGPointMake(width_2 + drawAreaW_2, height_2 - drawAreaW_2)];
    [(self.tintColor ?: UIColor.blackColor) setStroke];
    [path stroke];
}

@end
