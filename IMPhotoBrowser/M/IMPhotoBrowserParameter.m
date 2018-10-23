//
//  IMPhotoBrowserParameter.m
//  NiuYan
//
//  Created by 万涛 on 2018/10/23.
//  Copyright © 2018 niuyan.com. All rights reserved.
//

#import "IMPhotoBrowserParameter.h"

@implementation IMPhotoBrowserParameter

+ (instancetype)parameterWithImageUrlStrArray:(NSArray<NSString *> *)imageUrlStrArray thumbSuffix:(NSString * _Nullable)thumbSuffix currentIndex:(NSInteger)currentIndex {
    IMPhotoBrowserParameter *parameter = [[IMPhotoBrowserParameter alloc] init];
    parameter.imageUrlStrArray = imageUrlStrArray;
    parameter.thumbSuffix = thumbSuffix;
    parameter.currentIndex = currentIndex;
    return parameter;
}

+ (instancetype)parameterWithImageArray:(NSArray<UIImage *> *)imageArray currentIndex:(NSInteger)currentIndex {
    IMPhotoBrowserParameter *parameter = [[IMPhotoBrowserParameter alloc] init];
    parameter.imageArray = imageArray;
    parameter.currentIndex = currentIndex;
    return parameter;
}

@end
