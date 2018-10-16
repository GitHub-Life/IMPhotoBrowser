//
//  IMPhotoCollectionViewCell.h
//  IMPhotoBrowser
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPBStatement.h"
@class IMPhoto;

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IMPhoto *photo;

@property (nonatomic, assign) BOOL disableSelect;

@property (nonatomic, strong) IMPBPhotoSelectEvent photoSelectEvent;

@end

NS_ASSUME_NONNULL_END
