//
//  CollectionViewController.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/13.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "CollectionViewController.h"
#import "IMPhotoCollectionViewCell.h"
#import "IMPhotoManager.h"
#import "IMPhotoPickerContainerViewController.h"
#import "IMNetworkPhotoBrowserViewController.h"
#import "IMPhoto.h"

static NSString *const CellIdentifier = @"IMPhotoCollectionViewCell";

@interface CollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *photoArray;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.collectionView.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self.collectionView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
}

- (void)setPhotoArray:(NSArray *)photoArray {
    _photoArray = photoArray;
    [self.collectionView reloadData];
}

#pragma mark <UICollectionView DataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count ?: 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.photo = self.photoArray.count ? self.photoArray[indexPath.row] : nil;
    return cell;
}

#pragma mark - UICollectionView Delegate FlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    /*
    __weak typeof(self) weakSelf = self;
    [IMPhotoManager checkPhotoLibraryPermissionsWithFromVC:self GrantedBlock:^{
        IMPhotoPickerContainerViewController *photoPickerContainerVC = [[IMPhotoPickerContainerViewController alloc] initWithPhotoMaxCount:3 selectEvent:^(NSArray<IMPhoto *> *photoArray) {
            weakSelf.photoArray = photoArray;
        }];
        [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:photoPickerContainerVC] animated:YES completion:nil];
    }];
     */
    NSArray<IMPhoto *> *photoArray = @[[IMPhoto photoWithImageUrlStr:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539768809436&di=021a36655943b67d1859988aa6c17840&imgtype=0&src=http%3A%2F%2Ffile29.mafengwo.net%2FM00%2F7B%2F34%2FwKgBpVYdGOiAS71LAABuKaLQB_887.groupinfo.w600.jpeg"],
                                       [IMPhoto photoWithImageUrlStr:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539768809436&di=135659b8f0e2cbc43712e2898d47e0af&imgtype=0&src=http%3A%2F%2Fa3.topitme.com%2F0%2F82%2F57%2F11302368668ab57820o.jpg"],
                                       [IMPhoto photoWithImageUrlStr:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539768809435&di=3b108163c2b8660f5a0e062127f71fe0&imgtype=0&src=http%3A%2F%2Fwww.tupperware.com.cn%2Ffileserver%2Fproduct%2F201407%2F2014-7-24_15-14-16_979_401_b.jpg"],
                                       [IMPhoto photoWithImageUrlStr:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539768809432&di=71696b391c3f66584302146139a00e26&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F4d086e061d950a7bb88c27ff01d162d9f2d3c954.jpg"],
                                       [IMPhoto photoWithImageUrlStr:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539768809432&di=40aadb1697152615de85eccc00d07ab5&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D176e4adf49a98226accc2364e2ebd374%2Fcefc1e178a82b901b63a0b99798da9773812ef82.jpg"]];
    IMNetworkPhotoBrowserViewController *photoBrowserVC = [[IMNetworkPhotoBrowserViewController alloc] initWithPhotoArray:photoArray currentIndex:0];
    [self presentViewController:photoBrowserVC animated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemLength = (CGRectGetWidth(UIScreen.mainScreen.bounds) - 2) / 3;
    return CGSizeMake(itemLength, itemLength);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.f;
}

@end
