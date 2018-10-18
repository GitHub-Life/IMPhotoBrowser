//
//  IMPhotoAlbumTableViewCell.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoAlbumTableViewCell.h"
#import "IMPBStatement.h"

@interface IMPhotoAlbumTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel1;

@end

@implementation IMPhotoAlbumTableViewCell

- (void)setAlbumDict:(NSDictionary *)albumDict {
    _albumDict = albumDict;
    PHAssetCollection *collection = albumDict[IMPBAlbumKey];
    _imgView.image = albumDict[IMPBAlbumThumbKey];
    _valueLabel.text = collection.localizedTitle;
//    _valueLabel.text = [NSString stringWithFormat:@"%@ - %@", collection.localizedTitle, collection.localIdentifier];
    _valueLabel1.text = [NSString stringWithFormat:@"%@", albumDict[IMPBAlbumPhotoCountKey]];
}

@end
