//
//  IMPhotoCollectionViewController.m
//  IMPhotoBrowser
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoCollectionViewController.h"
#import "UIViewController+IMTakePhoto.h"
#import "UIViewController+IMAlert.h"
#import "IMPhotoCollectionViewCell.h"
#import "IMPhoto.h"

#import "IMPhotoBrowserViewController.h"

static NSInteger ColumnCount = 4;
static NSString * const CellIdentifier = @"IMPhotoCollectionViewCell";

@interface IMPhotoCollectionViewController ()

@property (nonatomic, assign) NSInteger maxCount;

@end

@implementation IMPhotoCollectionViewController

- (instancetype)initWithChoosePhotoMaxCount:(NSInteger)maxCount {
    self = [self init];
    self.maxCount = maxCount;
    return self;
}

- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemLength = (CGRectGetWidth(UIScreen.mainScreen.bounds) - (ColumnCount - 1) * 1.f) / ColumnCount;
    flowLayout.itemSize = CGSizeMake(itemLength, itemLength);
    flowLayout.minimumLineSpacing = 1.f;
    flowLayout.minimumInteritemSpacing = 1.f;
    self = [super initWithCollectionViewLayout:flowLayout];
    return self;
}

- (void)setPhotoArray:(NSArray<IMPhoto *> *)photoArray {
    _photoArray = photoArray;
    [self.collectionView reloadData];
}

- (void)setDisableSelectOther:(BOOL)disableSelectOther {
    if (disableSelectOther == _disableSelectOther) return;
    _disableSelectOther = disableSelectOther;
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.collectionView.backgroundColor = UIColor.clearColor;
    [self.collectionView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.disableSelect = self.disableSelectOther;
    if (indexPath.row == 0) {
        cell.photo = nil;
    } else {
        cell.photo = self.photoArray[indexPath.row - 1];
        [cell setPhotoSelectEvent:_photoSelectEvent];
    }
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.disableSelectOther) {
        if (indexPath.row == 0 || !self.photoArray[indexPath.row - 1].selected) {
            [self alertMessage:[NSString stringWithFormat:@"当前最多选择%d张图片", (int)self.maxCount]];
            return;
        }
    }
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        [self.navigationController takePhotoWithResult:^(UIImage * _Nullable image) {
            if (image && weakSelf.photoSelectEvent) {
                IMPhoto *photo = [IMPhoto photoWithImage:image];
                photo.isTakePhoto = YES;
                weakSelf.photoSelectEvent(photo);
            }
        }];
        return;
    }
    
    IMPhotoBrowserViewController *browserVC = [[IMPhotoBrowserViewController alloc] initWithPhotoArray:self.photoArray.copy currentIndex:indexPath.row - 1 maxCount:self.maxCount];
    [browserVC setPhotoSelectEvent:_photoSelectEvent];
    [browserVC setBrowseFinish:self.browseFinish];
    [browserVC.animationTransitioning setOriginalViewRectBlock:^NSValue *(NSInteger index) {
        NSInteger targetIndex = index + 1;
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)weakSelf.collectionViewLayout;
        NSInteger line = targetIndex / ColumnCount;
        NSInteger column = targetIndex % ColumnCount;
        CGFloat x = column * (flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing);
        CGFloat y = line * (flowLayout.itemSize.height + flowLayout.minimumLineSpacing);
        CGRect frame = [weakSelf.collectionView convertRect:CGRectMake(x, y, flowLayout.itemSize.width, flowLayout.itemSize.height) toView:UIApplication.sharedApplication.keyWindow];
        return [NSValue valueWithCGRect:frame];
    }];
    [browserVC.animationTransitioning setOriginalViewBlock:^UIView *(NSInteger index) {
        return [weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index + 1 inSection:0]];
    }];
    [self presentViewController:browserVC animated:YES completion:nil];
}

@end
