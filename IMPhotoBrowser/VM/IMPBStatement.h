//
//  IMPBStatement.h
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#ifndef IMPBStatement_h
#define IMPBStatement_h

#import "IMPhoto.h"
#import "IMPhotoManager.h"

#define IMPBAlbumKey @"collection"
#define IMPBAlbumThumbKey @"thumb"
#define IMPBAlbumPhotoCountKey @"count"

typedef void(^IMPBPhotoArraySelectedEvent)(NSArray<IMPhoto *> *photoArray);
typedef void(^IMPBPhotoSelectedEvent)(IMPhoto *photo);
typedef NSInteger(^IMPBPhotoSelectEvent)(IMPhoto *photo);
typedef void(^IMPBPhotoBrowseFinishEvent)(NSInteger index);
typedef void(^IMPBPhotoBrowsePageChangedEvent)(NSInteger page);
typedef void(^IMPBPhotoBrowseSingleTapEvent)(void);
@class UIView;
typedef UIView *(^IMPBAnimationViewBlock)(NSInteger index);

#endif /* IMPBStatement_h */
