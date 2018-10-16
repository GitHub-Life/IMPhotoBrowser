//
//  IMPhotoBrowserHeaderView.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/15.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoBrowserHeaderView.h"
#import <Masonry.h>

#import "IMPBCloseButton.h"

@interface IMPhotoBrowserHeaderView ()

@property (nonatomic, assign) CGFloat statusBarHeight;

@end

@implementation IMPhotoBrowserHeaderView

- (instancetype)initWithTotalCount:(NSInteger)totalCount {
    if (self = [super init]) {
        _totalCount = totalCount;
        [self initSettings];
    }
    return self;
}

- (void)initSettings {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33f];
    _statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = UIColor.whiteColor;
    _countLabel.font = [UIFont systemFontOfSize:18.f];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_countLabel];
    __weak typeof(self) weakSelf = self;
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(weakSelf.statusBarHeight, 0, 0, 0));
    }];
    [self updateCurrentIndex];
    
    _closeBtn = [IMPBCloseButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.tintColor = UIColor.whiteColor;
    [self addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.statusBarHeight);
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(HeaderViewHeight);
    }];
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 16)];
    _completeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_completeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_completeBtn setTitle:@"" forState:UIControlStateDisabled];
    [self addSubview:_completeBtn];
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.statusBarHeight);
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
    if (_countLabel) {
        _countLabel.text = [NSString stringWithFormat:@"%d / %d", (int)(self.currentIndex + 1), (int)self.totalCount];
    }
}

- (void)addToTargetView:(UIView *)targetView {
    [targetView addSubview:self];
    __weak typeof(self) weakSelf = self;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.height.mas_equalTo(HeaderViewHeight + weakSelf.statusBarHeight);
    }];
}

@end
