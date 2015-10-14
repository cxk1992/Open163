//
//  DownloadListViewController.m
//  Open163
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "DownloadListViewController.h"
#import "DownloadManager.h"
#import "DownloadTableViewCell.h"

@interface DownloadListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSDictionary * downloadList;

@property (nonatomic,strong) NSDictionary * completeList;

@property (nonatomic,assign) BOOL isDownlaod;

@property (nonatomic,strong) NSMutableDictionary * deleteDictionary;

@end

@implementation DownloadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self getData];
}

- (void)configTableView{
    [_tableView registerNib:[UINib nibWithNibName:@"DownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"downloadCell"];
}

- (void)getData{
    _downloadList = [[DownloadManager shareManager] downloadList];
    _completeList = [[DownloadManager shareManager] completeList];
    [_tableView reloadData];
}

- (void)deleteAction:(UIButton *)btn{
    DownloadTableViewCell *cell = (DownloadTableViewCell *)btn.superview.superview;
    [[DownloadManager shareManager] deleteMissionWithTitle:cell.courseTitle andSubTitle:cell.titleLabel.text];
    [self getData];
}

- (void)downloadAction:(UIButton *)btn{
    DownloadTableViewCell *cell = (DownloadTableViewCell *)btn.superview.superview;
    DownloadManager *manager = [DownloadManager shareManager];
    [manager startDownloadWithTitle:cell.courseTitle andCourseName:cell.titleLabel.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UItableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _downloadList.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_downloadList[_downloadList.allKeys[section]] allKeys].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadCell" forIndexPath:indexPath];
    cell.courseTitle = _downloadList.allKeys[indexPath.section];
    cell.titleLabel.text = [_downloadList[cell.courseTitle] allKeys][indexPath.row];
    [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    label.text = _downloadList.allKeys[section];
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

@end
