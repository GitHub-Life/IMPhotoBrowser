//
//  IMStatusBarTool.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/15.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMStatusBarTool.h"

@implementation IMStatusBarTool

+ (void)statusBar:(BOOL)show {
    NSArray *windows = UIApplication.sharedApplication.windows;
    NSLog(@" - %@ - ", windows);
}

@end
