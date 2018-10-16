//
//  UIViewController+IMTakePhoto.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "UIViewController+IMTakePhoto.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>

@implementation UIViewController (IMTakePhoto)

- (void)takePhotoWithResult:(void(^)(UIImage *))result {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized) {
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"无法打开相机，请检查拍照权限" preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alertC addAction:[UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }]];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        return;
    }
    self.resultBlock = result;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:imagePickerController animated:YES completion:nil];
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

#pragma mark - ResultBlock
static char *const ResultBlockKey = "IM_ResultBlockKey";
- (void)setResultBlock:(IMTakePhotoResultBlock)resultBlock {
    objc_setAssociatedObject(self, ResultBlockKey, resultBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (IMTakePhotoResultBlock)resultBlock {
    return objc_getAssociatedObject(self, ResultBlockKey);
}

@end
