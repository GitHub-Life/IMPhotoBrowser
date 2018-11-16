//
//  IMPhotoAlbumTableViewController.m
//  IMPhotoBrowserDemo
//
//  Created by 万涛 on 2018/10/11.
//  Copyright © 2018 iMoon. All rights reserved.
//

#import "IMPhotoAlbumTableViewController.h"

#import "IMPhotoManager.h"
#import "IMPhotoAlbumTableViewCell.h"
#import "IMPhotoCollectionViewController.h"

static NSString *const CellIdentifier = @"IMPhotoAlbumTableViewCell";

@interface IMPhotoAlbumTableViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray<NSDictionary *> *photoAlbumArray;

@end

@implementation IMPhotoAlbumTableViewController

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33];
        _bgView.alpha = 0;
        _bgView.hidden = YES;
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGrEvent:)];
        tapGr.delegate = self;
        [_bgView addGestureRecognizer:tapGr];
    }
    return _bgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    [self.tableView setBackgroundColor:UIColor.clearColor];
    [self.tableView setRowHeight:50.f];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    self.photoAlbumArray = [IMPhotoManager getAllPhotoAlbumArray];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoAlbumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMPhotoAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.albumDict = self.photoAlbumArray[indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_albumSelectedBlock) {
        _albumSelectedBlock(self.photoAlbumArray[indexPath.row][IMPBAlbumKey]);
    }
}

#pragma mark - 单击事件
- (void)tapGrEvent:(UITapGestureRecognizer *)tapGr {
    if (_albumSelectedBlock) {
        _albumSelectedBlock(nil);
    }
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return [self.tableView indexPathForRowAtPoint:[gestureRecognizer locationInView:self.tableView]] == nil;
}

@end
