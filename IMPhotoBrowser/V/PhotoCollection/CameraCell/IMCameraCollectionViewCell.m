//
//  IMCameraCollectionViewCell.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/17.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMCameraCollectionViewCell.h"

@implementation IMCameraCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [imgView setContentMode:UIViewContentModeCenter];
        [imgView setImage:[UIImage imageNamed:@"im_ico_camera"]];
        [self addSubview:imgView];
    }
    return self;
}

@end
