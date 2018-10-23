//
//  IMPhotoBrowserParameter.h
//  NiuYan
//
//  Created by 万涛 on 2018/10/23.
//  Copyright © 2018 niuyan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPBStatement.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMPhotoBrowserParameter : NSObject

@property (nonatomic, strong) NSArray<UIImage *> *imageArray;

@property (nonatomic, strong) NSArray<NSString *> *imageUrlStrArray;

@property (nonatomic, copy) NSString *thumbSuffix;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) UIViewController *callerVC;

@property (nonatomic, strong) IMPBAnimationViewBlock originalViewBlock;

+ (instancetype)parameterWithImageUrlStrArray:(NSArray<NSString *> *)imageUrlStrArray thumbSuffix:(NSString * _Nullable)thumbSuffix currentIndex:(NSInteger)currentIndex;

+ (instancetype)parameterWithImageArray:(NSArray<UIImage *> *)imageArray currentIndex:(NSInteger)currentIndex;

@end

NS_ASSUME_NONNULL_END
