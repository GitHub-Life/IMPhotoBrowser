//
//  UIView+IMLoading.m
//  NiuYan
//
//  Created by 万涛 on 2018/9/12.
//  Copyright © 2018年 niuyan.com. All rights reserved.
//

#import "UIView+IMLoading.h"
#import <Masonry.h>

@interface IMLoadingMaskView : UIView
@end
@implementation IMLoadingMaskView
@end

@implementation UIView (IMLoading)

- (void)im_loading:(BOOL)loading {
    [self im_loading:loading color:nil];
}

- (void)im_loading:(BOOL)loading color:(UIColor *)color {
    [self im_loading:loading color:color maskColor:nil];
}

- (void)im_loading:(BOOL)loading color:(UIColor *)color maskColor:(UIColor *)maskColor {
    IMLoadingMaskView *maskView;
    for (UIView *subV in self.subviews) {
        if ([subV isKindOfClass:IMLoadingMaskView.class]) {
            maskView = (IMLoadingMaskView *)subV;
            break;
        }
    }
    if (loading && !maskView) {
        maskView = [[IMLoadingMaskView alloc] init];
        [self addSubview:maskView];
        maskView.backgroundColor = maskColor?:UIColor.clearColor;
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        aiv.color = color ?: UIColor.lightGrayColor;
        [maskView addSubview:aiv];
        [aiv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointZero);
        }];
        [aiv startAnimating];
    } else if (!loading && maskView) {
        [maskView removeFromSuperview];
    }
}

@end
