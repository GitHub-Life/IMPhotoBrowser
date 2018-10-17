//
//  IMPhotoPickerContainerViewController.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoPickerContainerViewController.h"
#import <Masonry.h>
#import "IMPhotoManager.h"
#import "IMPhoto.h"

#import "IMPhotoCollectionFooterView.h"
#import "IMPhotoCollectionViewController.h"
#import "IMPhotoAlbumTableViewController.h"
#import "IMPhotoBrowserViewController.h"

static CGFloat const FooterViewHeight = 44.f;

@interface IMPhotoPickerContainerViewController ()

@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, strong) IMPBPhotoSelectedEvent singleSelectedEvent;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) IMPBPhotoArraySelectedEvent multiSelectedEvent;
@property (nonatomic, strong) NSMutableArray<IMPhoto *> *selectedPhotoArray;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) IMPhotoCollectionFooterView *footerView;
@property (nonatomic, strong) IMPhotoCollectionViewController *photoCollectionVC;
@property (nonatomic, strong) IMPhotoAlbumTableViewController *photoAlbumTableVC;
@property (nonatomic, strong) UIView *albumTableBgView;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<IMPhoto *> *> *allPhotoDatas;

@property (nonatomic, strong) PHAssetCollection *currentCollection;

@property (nonatomic, strong) IMPBPhotoSelectEvent photoSelectEvent;
@property (nonatomic, strong) IMPBPhotoBrowseFinishEvent browseFinish;

@end

@implementation IMPhotoPickerContainerViewController

#pragma mark - 初始化
- (instancetype)initWithPhotoMaxCount:(NSInteger)maxCount multiSelectedEvent:(nonnull IMPBPhotoArraySelectedEvent)multiSelectedEvent {
    if (self = [super init]) {
        self.maxCount = maxCount;
        self.multiSelectedEvent = multiSelectedEvent;
    }
    return self;
}

- (instancetype)initWithCutedSelectedEvent:(IMPBPhotoSelectedEvent)singleSelectedEvent {
    if (self = [super init]) {
        self.maxCount = 1;
        self.allowsEditing = YES;
        self.singleSelectedEvent = singleSelectedEvent;
    }
    return self;
}

#pragma mark - 懒加载
- (NSMutableArray<IMPhoto *> *)selectedPhotoArray {
    if (!_selectedPhotoArray) {
        _selectedPhotoArray = [NSMutableArray arrayWithCapacity:self.maxCount];
    }
    return _selectedPhotoArray;
}

- (NSMutableDictionary<NSString *, NSArray<IMPhoto *> *> *)allPhotoDatas {
    if (!_allPhotoDatas) {
        _allPhotoDatas = [NSMutableDictionary dictionary];
    }
    return _allPhotoDatas;
}

- (IMPBPhotoSelectEvent)photoSelectEvent {
    if (!_photoSelectEvent) {
        __weak typeof(self) weakSelf = self;
        _photoSelectEvent = ^NSInteger(IMPhoto *photo) {
            if (photo.isTakePhoto) {
                if (weakSelf.allowsEditing) {
                    if (weakSelf.singleSelectedEvent) {
                        weakSelf.singleSelectedEvent(photo);
                    }
                    [weakSelf cancelBack];
                } else {
                    [weakSelf.selectedPhotoArray addObject:photo];
                    [weakSelf complete];
                }
            } else {
                if (photo.selected && ![weakSelf.selectedPhotoArray containsObject:photo]) {
                    if (weakSelf.selectedPhotoArray.count >= self.maxCount) return -1;
                    [weakSelf.selectedPhotoArray addObject:photo];
                } else if (!photo.selected) {
                    [weakSelf.selectedPhotoArray removeObject:photo];
                }
            }
            return [weakSelf checkSelectedPhotoCount];
        };
    }
    return _photoSelectEvent;
}

- (IMPBPhotoBrowseFinishEvent)browseFinish {
    if (!_browseFinish) {
        __weak typeof(self) weakSelf = self;
        _browseFinish = ^(NSInteger index) {
            if (weakSelf.allowsEditing) {
                IMPhoto *photo = weakSelf.photoCollectionVC.photoArray[index];
                if (weakSelf.singleSelectedEvent) {
                    weakSelf.singleSelectedEvent(photo);
                }
                [weakSelf cancelBack];
            } else {
                if (index < 0) {
                    [weakSelf complete];
                } else {
                    [weakSelf.photoCollectionVC.collectionView reloadData];
                }
            }
        };
    }
    return _browseFinish;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    [self setNavigationBar];
    
    _containerView = [[UIView alloc] init];
    [self.view addSubview:_containerView];
    __weak typeof(self) weakSelf = self;
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideTop);
            make.left.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideLeft);
            make.right.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideRight);
            make.bottom.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsMake(CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame) + 44.f, 0, 0, 0));
        }
    }];
    
    [self setFooterView];
    
    NSArray<IMPhoto *> *photoArray = [IMPhotoManager getPhotoArrayWithAssetCollection:self.currentCollection];
    self.allPhotoDatas[self.currentCollection.localIdentifier] = photoArray;
    self.photoCollectionVC.photoArray = photoArray;
}

- (void)setFooterView {
    if (!self.allowsEditing) {
        _footerView = [[IMPhotoCollectionFooterView alloc] init];
        [_footerView.previewBtn addTarget:self action:@selector(previewSelectedPhotoArray) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.completeBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_footerView];
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0);
            make.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(FooterViewHeight);
        }];
    }
}

- (void)setNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelBack)];
    [self.navigationController.navigationBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumTableShowHide)]];
    self.currentCollection = [IMPhotoManager getSmartPhotoAlbumArray].firstObject[IMPBAlbumKey];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ ▼", self.currentCollection.localizedTitle];
}

#pragma mark - 预览选择的照片集合
- (void)previewSelectedPhotoArray {
    IMPhotoBrowserViewController *browserVC = [[IMPhotoBrowserViewController alloc] initWithPhotoArray:self.selectedPhotoArray.copy currentIndex:0 maxCount:self.maxCount];
    [browserVC setPhotoSelectEvent:self.photoSelectEvent];
    [browserVC setBrowseFinish:self.browseFinish];
    [self presentViewController:browserVC animated:YES completion:nil];
}

#pragma mark - 检查选中的照片数量
- (NSInteger)checkSelectedPhotoCount {
    NSInteger selectedPhotoCount = self.selectedPhotoArray.count;
    self.footerView.completeBtn.enabled = selectedPhotoCount > 0;
    self.footerView.previewBtn.enabled = selectedPhotoCount > 0;
    if (self.footerView.completeBtn.enabled) {
        [self.footerView.completeBtn setTitle:[NSString stringWithFormat:@"完成(%d)", (int)self.selectedPhotoArray.count] forState:UIControlStateNormal];
    }
    self.photoCollectionVC.disableSelectOther = selectedPhotoCount >= self.maxCount;
    return self.selectedPhotoArray.count;
}

#pragma mark - 照片列表
- (IMPhotoCollectionViewController *)photoCollectionVC {
    if (!_photoCollectionVC) {
        _photoCollectionVC = [[IMPhotoCollectionViewController alloc] initWithPhotoMaxCount:self.maxCount];
        _photoCollectionVC.allowsEditing = self.allowsEditing;
        [_containerView addSubview:_photoCollectionVC.collectionView];
        __weak typeof(self) weakSelf = self;
        [_photoCollectionVC.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (weakSelf.allowsEditing) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            } else {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, FooterViewHeight, 0));
            }
        }];
        [_photoCollectionVC setPhotoSelectEvent:self.photoSelectEvent];
        [_photoCollectionVC setBrowseFinish:self.browseFinish];
        [self addChildViewController:_photoCollectionVC];
    }
    return _photoCollectionVC;
}

#pragma mark - 相册列表
- (IMPhotoAlbumTableViewController *)photoAlbumTableVC {
    if (!_photoAlbumTableVC) {
        _albumTableBgView = [[UIView alloc] init];
        _albumTableBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33];
        _albumTableBgView.alpha = 0;
        _albumTableBgView.hidden = YES;
        [_containerView addSubview:_albumTableBgView];
        [_albumTableBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        _photoAlbumTableVC = [[IMPhotoAlbumTableViewController alloc] init];
        _photoAlbumTableVC.tableView.hidden = YES;
        [_containerView addSubview:_photoAlbumTableVC.tableView];
        [_photoAlbumTableVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 100, 0));
        }];
        _photoAlbumTableVC.tableView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.photoAlbumTableVC.tableView.bounds));
        __weak typeof(self) weakSelf = self;
        [_photoAlbumTableVC setAlbumSelectedBlock:^(PHAssetCollection * _Nullable assetCollection) {
            if (assetCollection) {
                weakSelf.currentCollection = assetCollection;
                NSArray<IMPhoto *> *photoArray = weakSelf.allPhotoDatas[assetCollection.localIdentifier];
                if (!photoArray) {
                    photoArray = [IMPhotoManager getPhotoArrayWithAssetCollection:assetCollection];
                    weakSelf.allPhotoDatas[assetCollection.localIdentifier] = photoArray;
                }
                weakSelf.photoCollectionVC.photoArray = photoArray;
            }
            [weakSelf albumTableShowHide];
        }];
        [self addChildViewController:_photoAlbumTableVC];
    }
    return _photoAlbumTableVC;
}

#pragma mark - 相册列表的显示/隐藏
- (void)albumTableShowHide {
    if (self.photoAlbumTableVC.tableView.hidden) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ ▲", self.currentCollection.localizedTitle];
        self.photoAlbumTableVC.tableView.hidden = NO;
        self.albumTableBgView.hidden = NO;
        [UIView animateWithDuration:0.3f delay:0.f usingSpringWithDamping:0.8f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.photoAlbumTableVC.tableView.transform = CGAffineTransformIdentity;
            self.albumTableBgView.alpha = 1;
        } completion:nil];
    } else {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ ▼", self.currentCollection.localizedTitle];
        [UIView animateWithDuration:0.3 animations:^{
            self.photoAlbumTableVC.tableView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.photoAlbumTableVC.tableView.bounds));
            self.albumTableBgView.alpha = 0;
        } completion:^(BOOL finished) {
            self.photoAlbumTableVC.tableView.hidden = YES;
            self.albumTableBgView.hidden = YES;
        }];
    }
}

#pragma mark - 完成
- (void)complete {
    if (self.multiSelectedEvent) {
        self.multiSelectedEvent(self.selectedPhotoArray);
    }
    [self cancelBack];
}

#pragma mark - 取消/返回
- (void)cancelBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
