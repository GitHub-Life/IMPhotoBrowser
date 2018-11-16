//
//  IMPBPhotoView.h
//  NiuYan
//
//  Created by 万涛 on 2018/10/25.
//  Copyright © 2018 niuyan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPBStatement.h"
@class IMPBPhotoView;

NS_ASSUME_NONNULL_BEGIN

typedef void(^IMPBPhotoViewTapEvent)(IMPBPhotoView *photoView);

@interface IMPBPhotoView : UIView

@property (nonatomic, strong, nullable) IMPhoto *photo;
/** 是否显示 缩略图 */
@property (nonatomic, assign) IBInspectable BOOL thumb;

@property (nonatomic, assign) IBInspectable NSInteger im_tag;

@property (nonatomic, strong) IMPBPhotoViewTapEvent tapEvent;

@property (nonatomic, assign) IBInspectable BOOL canDelete;
@property (nonatomic, strong) UIButton *deleteBtn;
/** 发起浏览图片的ViewController */
@property (nonatomic, weak) UIViewController *browserCallerVC;

@end

NS_ASSUME_NONNULL_END
