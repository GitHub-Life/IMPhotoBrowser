//
//  IMPhotoBrowserHeaderFooterView.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/15.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoBrowserHeaderFooterView : UIView

- (instancetype)initWithTotalCount:(NSInteger)totalCount;

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *rightBtn;

/** 是显示于底部，否则显示于顶部 */
@property (nonatomic, assign) BOOL isFooter;

- (void)addToTargetView:(UIView *)targetView;

@end

NS_ASSUME_NONNULL_END
