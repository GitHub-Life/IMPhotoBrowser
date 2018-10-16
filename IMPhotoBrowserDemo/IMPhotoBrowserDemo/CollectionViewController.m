//
//  CollectionViewController.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/13.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "CollectionViewController.h"
#import "IMPhotoCollectionViewCell.h"
#import "IMPhotoPickerContainerViewController.h"

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
    __weak typeof(self) weakSelf = self;
    IMPhotoPickerContainerViewController *photoPickerContainerVC = [[IMPhotoPickerContainerViewController alloc] initWithChoosePhotoMaxCount:9 selectEvent:^(NSArray<IMPhoto *> *photoArray) {
        weakSelf.photoArray = photoArray;
    }];
    [self presentViewController:photoPickerContainerVC.naviVC animated:YES completion:nil];
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
