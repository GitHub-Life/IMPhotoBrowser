//
//  IMPhotoAlbumTableViewController.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAssetCollection;

NS_ASSUME_NONNULL_BEGIN

typedef void(^IMPhotoAlbumSelectedBlock)(PHAssetCollection * __nullable assetCollection);

@interface IMPhotoAlbumTableViewController : UITableViewController

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) IMPhotoAlbumSelectedBlock albumSelectedBlock;

@end

NS_ASSUME_NONNULL_END
