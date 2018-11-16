//
//  UIView+IMLoading.h
//  NiuYan
//
//  Created by 万涛 on 2018/9/12.
//  Copyright © 2018年 niuyan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IMLoading)

- (void)im_loading:(BOOL)loading;

- (void)im_loading:(BOOL)loading color:(UIColor *)color;

- (void)im_loading:(BOOL)loading color:(UIColor *)color maskColor:(UIColor *)maskColor;

@end
