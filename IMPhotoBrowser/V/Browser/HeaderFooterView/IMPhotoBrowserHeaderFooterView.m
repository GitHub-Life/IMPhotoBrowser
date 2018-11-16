//
//  IMPhotoBrowserHeaderFooterView.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/15.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoBrowserHeaderFooterView.h"
#import <Masonry.h>

#import "IMPBXButton.h"

static CGFloat const HeaderViewHeight = 44.f;

@implementation IMPhotoBrowserHeaderFooterView

- (instancetype)initWithTotalCount:(NSInteger)totalCount {
    if (self = [super init]) {
        _totalCount = totalCount;
        [self initSettings];
    }
    return self;
}

- (void)initSettings {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33f];
    
    UIView *containerView = [[UIView alloc] init];
    [self addSubview:containerView];
    __weak typeof(self) weakSelf = self;
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(weakSelf.mas_safeAreaLayoutGuideTop);
            make.left.mas_equalTo(weakSelf.mas_safeAreaLayoutGuideLeft);
            make.right.mas_equalTo(weakSelf.mas_safeAreaLayoutGuideRight);
            make.bottom.mas_equalTo(weakSelf.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }
        make.height.mas_equalTo(HeaderViewHeight);
    }];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = UIColor.whiteColor;
    _countLabel.font = [UIFont systemFontOfSize:18.f];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self updateCurrentIndex];
    
    _closeBtn = [IMPBXButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.tintColor = UIColor.whiteColor;
    [containerView addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(HeaderViewHeight);
    }];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 16)];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [containerView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setTotalCount:(NSInteger)totalCount {
    _totalCount = totalCount;
    [self updateCurrentIndex];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [self updateCurrentIndex];
}

- (void)updateCurrentIndex {
    if (_totalCount <= 1) {
        if (!_countLabel.hidden) {
            _countLabel.hidden = YES;
        }
        return;
    }
    if (_countLabel) {
        _countLabel.text = [NSString stringWithFormat:@"%d / %d", (int)(self.currentIndex + 1), (int)self.totalCount];
    }
}

- (void)addToTargetView:(UIView *)targetView {
    [targetView addSubview:self];
    __weak typeof(self) weakSelf = self;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (weakSelf.isFooter) {
            make.bottom.mas_equalTo(0);
        } else {
            make.top.mas_equalTo(0);
        }
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
    }];
}

@end
