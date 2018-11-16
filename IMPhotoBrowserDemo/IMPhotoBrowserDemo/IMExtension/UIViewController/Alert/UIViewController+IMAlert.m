//
//  UIViewController+IMAlert.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/13.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "UIViewController+IMAlert.h"

@implementation UIViewController (IMAlert)

- (void)alertMessage:(NSString *)message {
    if (!message.length) return;
    CGFloat duration = message.length / 20.f;
    if (duration < 0.5f) duration = 0.5f;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertC animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertC dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

@end
