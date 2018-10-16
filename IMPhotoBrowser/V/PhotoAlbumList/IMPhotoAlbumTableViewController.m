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

@interface IMPhotoAlbumTableViewController ()

@property (nonatomic, strong) NSArray<NSDictionary *> *photoAlbumArray;

@end

@implementation IMPhotoAlbumTableViewController

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

@end
