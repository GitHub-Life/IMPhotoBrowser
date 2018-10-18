//
//  ViewController.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "ViewController.h"
#import "IMPhotoBrowser.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<IMPhoto *> *photoArray;

@property (nonatomic, assign) CGFloat itemSize;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
}

- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 0: {
            NSArray<IMPhoto *> *photoArray = @[[IMPhoto photoWithImageUrlStr:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539768809436&di=021a36655943b67d1859988aa6c17840&imgtype=0&src=http%3A%2F%2Ffile29.mafengwo.net%2FM00%2F7B%2F34%2FwKgBpVYdGOiAS71LAABuKaLQB_887.groupinfo.w600.jpeg"],
                                               [IMPhoto photoWithImageUrlStr:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539768809436&di=135659b8f0e2cbc43712e2898d47e0af&imgtype=0&src=http%3A%2F%2Fa3.topitme.com%2F0%2F82%2F57%2F11302368668ab57820o.jpg"],
                                               [IMPhoto photoWithImageUrlStr:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539768809435&di=3b108163c2b8660f5a0e062127f71fe0&imgtype=0&src=http%3A%2F%2Fwww.tupperware.com.cn%2Ffileserver%2Fproduct%2F201407%2F2014-7-24_15-14-16_979_401_b.jpg"],
                                               [IMPhoto photoWithImageUrlStr:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539768809432&di=71696b391c3f66584302146139a00e26&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F4d086e061d950a7bb88c27ff01d162d9f2d3c954.jpg"],
                                               [IMPhoto photoWithImageUrlStr:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539768809432&di=40aadb1697152615de85eccc00d07ab5&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D176e4adf49a98226accc2364e2ebd374%2Fcefc1e178a82b901b63a0b99798da9773812ef82.jpg"]];
            IMNetworkPhotoBrowserViewController *photoBrowserVC = [[IMNetworkPhotoBrowserViewController alloc] initWithPhotoArray:photoArray currentIndex:0];
            [self presentViewController:photoBrowserVC animated:YES completion:nil];
        } break;
        case 1: {
            __weak typeof(self) weakSelf = self;
            [IMPhotoManager checkPhotoLibraryPermissionsWithFromVC:self GrantedBlock:^{
                IMPhotoPickerViewController *pickerVC = [[IMPhotoPickerViewController alloc] initWithCutedSelectedEvent:^(IMPhoto *photo) {
                    weakSelf.photoArray = @[photo];
                }];
                [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:pickerVC] animated:YES completion:nil];
            }];
        } break;
        case 2: {
            __weak typeof(self) weakSelf = self;
            [IMPhotoManager checkPhotoLibraryPermissionsWithFromVC:self GrantedBlock:^{
                IMPhotoPickerViewController *pickerVC = [[IMPhotoPickerViewController alloc] initWithPhotoMaxCount:5 multiSelectedEvent:^(NSArray<IMPhoto *> *photoArray) {
                    weakSelf.photoArray = photoArray;
                }];
                [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:pickerVC] animated:YES completion:nil];
            }];
        } break;
    }
}

- (void)setPhotoArray:(NSArray<IMPhoto *> *)photoArray {
    _photoArray = photoArray;
    [self.collectionView reloadData];
}

#pragma mark - CollectionView
static NSString *const CellIdentifier = @"CellIdentifier";
- (void)initCollectionView {
    _itemSize = (CGRectGetWidth(UIScreen.mainScreen.bounds) - 2) / 3;
    [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:CellIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *imgView = [cell viewWithTag:100];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _itemSize, _itemSize)];
        [imgView setTag:100];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        [cell addSubview:imgView];
    }
    [self.photoArray[indexPath.row] getImageWithResult:^(UIImage * _Nullable image) {
        imgView.image = image;
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_itemSize, _itemSize);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.f;
}

@end
