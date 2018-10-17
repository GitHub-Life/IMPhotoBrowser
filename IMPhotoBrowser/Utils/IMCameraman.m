//
//  IMCameraman.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMCameraman.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+IMAlert.h"

@interface IMCameraman () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) IMCameramanResultBlock resultBlock;

@end

@implementation IMCameraman

- (void)takePhotoWithFromVC:(UIViewController *)fromVC result:(IMCameramanResultBlock)result {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [fromVC alertMessage:@"无可用摄像设备"];
        return;
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self takePhotoWithFromVC:fromVC result:result];
                }
            }];
        } break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted: {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"无法打开相机，请检查拍照权限" preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alertC addAction:[UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }]];
            [fromVC presentViewController:alertC animated:YES completion:nil];
        } break;
        case AVAuthorizationStatusAuthorized: {
            self.resultBlock = result;
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [fromVC presentViewController:imagePickerController animated:YES completion:nil];
        } break;
    }
}


#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (!image) {
            image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        [picker dismissViewControllerAnimated:(image==nil) completion:nil];
        if (self.resultBlock) {
            self.resultBlock(image);
        }
    });
}

@end
