//
//  IMPhotoBrowserCollectionView.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/13.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPBStatement.h"
@class IMPhoto;

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoBrowserCollectionView : UICollectionView

+ (UICollectionViewFlowLayout *)defaultFlowLayout;

@property (nonatomic, strong) NSArray<IMPhoto *> *photoArray;
- (void)setSelectedIndex:(NSInteger)selectedIndex;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong, readonly) IMPhoto *currentPhoto;
@property (nonatomic, strong, readonly) UIView *animView;

@property (nonatomic, strong) IMPBPhotoBrowseSingleTapEvent singleTapEvent;
@property (nonatomic, strong) IMPBPhotoBrowsePageChangedEvent pageChanged;

@end

NS_ASSUME_NONNULL_END
