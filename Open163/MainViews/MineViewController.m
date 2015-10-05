//
//  MineViewController.m
//  Open163
//
//  Created by qianfeng on 15/8/19.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "HistoryViewController.h"
#import "DownloadListViewController.h"

#define kReuseKey @"MineCell"

@interface MineViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    NSArray *_imageArray;
}
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, screenWidth, screenheight-95);
    [self configTableView];
}

- (void)configTableView{
    _dataArray = @[@"我的收藏",@"我的下载",@"播放记录",@"设置"];
    _imageArray = @[@"ico_my_favorites",@"ico_my_download",@"ico_my_history",@"ico_my_set"];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource  = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = [self getHeadView];
    _tableView.bounces = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:kReuseKey];
    [self.view addSubview:_tableView];
}

- (UIView *)getHeadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
    imageView.image = [UIImage imageNamed:@"ico_my_photo"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 200, 20)];
    label.text = @"尚未登录";
    [view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(screenWidth - 100, 30, 60, 20);
    [btn setTitle:@"立即登录" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_green_s_setting_pressed"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(LoginAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:btn];
    
    return view;
}

- (void)LoginAction:(UIButton *)btn{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configCell:(MineTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.titleLabel.text = _dataArray[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
}

- (void)dealloc{
    
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseKey forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HistoryViewController *hisVC = [[HistoryViewController alloc] init];
        [self rootNavigationPush:hisVC];
    }else if (indexPath.row == 1){
        DownloadListViewController *vc = [[DownloadListViewController alloc] init];
        [self rootNavigationPush:vc];
    }else if (indexPath.row == 2){
        HistoryViewController *hisVC = [[HistoryViewController alloc] init];
        hisVC.isHistory = YES;
        [self rootNavigationPush:hisVC];
    }
}


@end
