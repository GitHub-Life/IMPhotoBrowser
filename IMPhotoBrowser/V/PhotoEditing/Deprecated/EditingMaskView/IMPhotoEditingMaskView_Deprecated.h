//
//  IMPhotoEditingMaskView_Deprecated.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoEditingMaskView_Deprecated : UIView

@property (nonatomic, assign) CGFloat offsetY;

@property (nonatomic, assign, readonly) CGRect clipRect;

@property (nonatomic, assign) BOOL hideArrow;

@end

NS_ASSUME_NONNULL_END
