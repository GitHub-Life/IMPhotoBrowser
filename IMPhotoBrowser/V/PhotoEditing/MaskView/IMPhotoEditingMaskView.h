//
//  IMPhotoEditingMaskView.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/11/9.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPhotoEditingStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoEditingMaskView : UIVisualEffectView

- (instancetype)initWithEditingStyle:(IMPhotoEditingStyle)editingStyle frame:(CGRect)frame;

@property (nonatomic, assign) CGRect clipRect;

@property (nonatomic, assign) UIEdgeInsets clipRectMargin;

@end

NS_ASSUME_NONNULL_END
