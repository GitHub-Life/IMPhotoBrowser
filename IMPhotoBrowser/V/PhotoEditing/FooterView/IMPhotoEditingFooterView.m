//
//  IMPhotoEditingFooterView.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoEditingFooterView.h"
#import <Masonry.h>

static CGFloat const FooterViewHeight = 44.f;

@implementation IMPhotoEditingFooterView

- (instancetype)init {
    if (self = [super init]) {
        [self initSettings];
    }
    return self;
}

- (void)initSettings {
//    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33f];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 16)];
    [self addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.height.mas_equalTo(FooterViewHeight);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_completeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_completeBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 16)];
    [self addSubview:_completeBtn];
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
}

@end
