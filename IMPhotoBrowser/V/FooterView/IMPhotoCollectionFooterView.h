//
//  IMPhotoCollectionFooterView.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/15.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat const FooterViewHeight = 44.f;

@interface IMPhotoCollectionFooterView : UIView

@property (nonatomic, strong) UIButton *previewBtn;

@property (nonatomic, strong) UIButton *completeBtn;

@end

NS_ASSUME_NONNULL_END
