//
//  IMPhotoBrowserCollectionViewCell.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/13.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPBStatement.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoBrowserCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IMPhoto *photo;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) IMPBPhotoBrowseSingleTapEvent singleTapEvent;

@end

NS_ASSUME_NONNULL_END
