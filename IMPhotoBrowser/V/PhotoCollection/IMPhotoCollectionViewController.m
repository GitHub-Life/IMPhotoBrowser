//
//  IMPhotoCollectionViewController.m
//  IMPhotoBrowser
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoCollectionViewController.h"
#import "UIViewController+IMAlert.h"
#import "IMCameraman.h"
#import "IMCameraCollectionViewCell.h"
#import "IMPhotoCollectionViewCell.h"
#import "IMPhoto.h"

#import "IMPhotoBrowserViewController.h"
#import "IMSinglePhotoPreviewViewController.h"

static NSInteger ColumnCount = 4;
static NSString * const CameraCellIdentifier = @"CameraCellIdentifier";
static NSString * const PhotoCellIdentifier = @"IMPhotoCollectionViewCell";

@interface IMPhotoCollectionViewController ()

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, strong) IMCameraman *cameraman;

@end

@implementation IMPhotoCollectionViewController

- (instancetype)initWithPhotoMaxCount:(NSInteger)maxCount {
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
    [self.collectionView registerClass:IMCameraCollectionViewCell.class forCellWithReuseIdentifier:CameraCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:PhotoCellIdentifier bundle:nil] forCellWithReuseIdentifier:PhotoCellIdentifier];
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
    if (indexPath.row == 0) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:CameraCellIdentifier forIndexPath:indexPath];
    }
    IMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
    cell.disableSelect = self.disableSelectOther;
    cell.hideSelectBtn = self.allowsEditing;
    cell.photo = self.photoArray[indexPath.row - 1];
    [cell setPhotoSelectEvent:_photoSelectEvent];
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
        [self.cameraman takePhotoWithAllowsEditing:self.allowsEditing fromVC:self.navigationController result:^(UIImage * _Nullable image) {
            if (image && weakSelf.photoSelectEvent) {
                IMPhoto *photo = [IMPhoto photoWithImage:image];
                photo.isTakePhoto = YES;
                weakSelf.photoSelectEvent(photo);
            }
        }];
        return;
    }
    
    if (self.allowsEditing) {
        IMSinglePhotoPreviewViewController *previewVC = [[IMSinglePhotoPreviewViewController alloc] initWithPhoto:self.photoArray[indexPath.row - 1] browseFinish:self.browseFinish];
        [previewVC.animationTransitioning setOriginalViewBlock:^UIView *(NSInteger index) {
            return [weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index + 1 inSection:0]];
        }];
        [self presentViewController:previewVC animated:YES completion:nil];
    } else {
        IMPhotoBrowserViewController *browserVC = [[IMPhotoBrowserViewController alloc] initWithPhotoArray:self.photoArray.copy currentIndex:indexPath.row - 1 maxCount:self.maxCount];
        [browserVC setPhotoSelectEvent:_photoSelectEvent];
        [browserVC setBrowseFinish:self.browseFinish];
        [browserVC.animationTransitioning setOriginalViewBlock:^UIView *(NSInteger index) {
            return [weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index + 1 inSection:0]];
        }];
        [self presentViewController:browserVC animated:YES completion:nil];
    }
}

- (IMCameraman *)cameraman {
    if (!_cameraman) {
        _cameraman = [[IMCameraman alloc] init];
    }
    return _cameraman;
}

@end
