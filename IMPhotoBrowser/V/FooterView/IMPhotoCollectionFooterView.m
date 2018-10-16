//
//  IMPhotoCollectionFooterView.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/15.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoCollectionFooterView.h"
#import <Masonry.h>

@implementation IMPhotoCollectionFooterView

- (instancetype)init {
    if (self = [super init]) {
        [self initSettings];
    }
    return self;
}

- (void)initSettings {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.shadowOffset = CGSizeMake(0, -2);
    self.layer.shadowOpacity = 0.1f;
    self.layer.shadowRadius = 7.f;
    
    _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _previewBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
    [_previewBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [_previewBtn setTitleColor:UIColor.grayColor forState:UIControlStateDisabled];
    [_previewBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 16)];
    _previewBtn.enabled = NO;
    [self addSubview:_previewBtn];
    [_previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
    }];
}

@end
