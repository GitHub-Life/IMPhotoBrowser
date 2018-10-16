//
//  IMPhotoCollectionViewController.h
//  IMPhotoBrowser
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPBStatement.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoCollectionViewController : UICollectionViewController

- (instancetype)initWithChoosePhotoMaxCount:(NSInteger)maxCount;

@property (nonatomic, weak) NSArray<IMPhoto *> *photoArray;

@property (nonatomic, strong) IMPBPhotoSelectEvent photoSelectEvent;
@property (nonatomic, strong) IMPBPhotoBrowseFinishEvent browseFinish;

@property (nonatomic, assign) BOOL disableSelectOther;

@end

NS_ASSUME_NONNULL_END
