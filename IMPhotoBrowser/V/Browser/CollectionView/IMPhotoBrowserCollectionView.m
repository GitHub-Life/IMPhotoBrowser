//
//  IMPhotoBrowserCollectionView.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/13.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoBrowserCollectionView.h"
#import "IMPhotoBrowserCollectionViewCell.h"

static NSString *CellIdentifier = @"IMPhotoBrowserCollectionViewCell";

@interface IMPhotoBrowserCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation IMPhotoBrowserCollectionView

+ (UICollectionViewFlowLayout *)defaultFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = UIScreen.mainScreen.bounds.size;
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.minimumLineSpacing = 0.f;
    return flowLayout;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.collectionViewLayout = IMPhotoBrowserCollectionView.defaultFlowLayout;
        [self initView];
    }
    return self;
}

- (instancetype)init {
    self = [self initWithFrame:CGRectZero collectionViewLayout:IMPhotoBrowserCollectionView.defaultFlowLayout];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = UIColor.clearColor;
    self.dataSource = self;
    self.delegate = self;
    self.pagingEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    [self registerClass:IMPhotoBrowserCollectionViewCell.class forCellWithReuseIdentifier:CellIdentifier];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex >= 0 && selectedIndex < self.photoArray.count) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
        });
    }
}

- (void)setPhotoArray:(NSArray<IMPhoto *> *)photoArray {
    _photoArray  = photoArray ;
    [self reloadData];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray .count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IMPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.singleTapEvent = self.singleTapEvent;
    IMPhoto *photo = self.photoArray[indexPath.row];
    cell.photo = photo;
    return cell;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentIndex = round(scrollView.contentOffset.x / self.bounds.size.width);
    if (_pageChanged) {
        _pageChanged(self.currentIndex);
    }
}

#pragma mark - Readonly - Getter
- (IMPhoto *)currentPhoto {
    if (!_photoArray.count) return nil;
    if (_currentIndex < 0 || _currentIndex >= _photoArray.count) return nil;
    return _photoArray[_currentIndex];
}

- (UIView *)animView {
    IMPhotoBrowserCollectionViewCell *cell = (IMPhotoBrowserCollectionViewCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    if (cell.scrollView.zoomScale != 1.f) return nil;
    return cell.imageView;
}

#pragma mark - 保存当前显示的图片
- (void)saveCurrentPhotoWithFromVC:(UIViewController *)fromVC result:(nonnull void (^)(BOOL))result {
    if (self.currentIndex >= 0 && self.currentIndex < self.photoArray.count && self.photoArray[self.currentIndex].image) {
        IMPhoto *photo = self.photoArray[self.currentIndex];
        [IMPhotoManager checkPhotoLibraryPermissionsWithFromVC:fromVC GrantedBlock:^{
            UIImageWriteToSavedPhotosAlbum(self.photoArray[self.currentIndex].image, nil, nil, nil);
            photo.saved = YES;
            if (result) result(YES);
        }];
    }
}

@end
