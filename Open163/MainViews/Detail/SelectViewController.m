//
//  SelectViewController.m
//  Open163
//
//  Created by qianfeng on 15/8/29.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "SelectViewController.h"
#import "AppDelegate.h"
#import "AllCourseTableViewCell.h"
#import "AllCourseModel.h"
#import "AllCourseTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PlayerViewController.h"

@interface SelectViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *_dataList;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configTableView];
}

- (void)configTableView{
    [_tableView registerNib:[UINib nibWithNibName:@"AllCourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"allCourseCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configCell:(AllCourseTableViewCell *)cell withModel:(AllCourseModel *)model{
    [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.largeimgurl]];
    cell.titleLabel.text = model.title;
    cell.typeLabel.text = [NSString stringWithFormat:@"分类:%@",model.tags];
    cell.leftBottomLabel.text = [NSString stringWithFormat:@"集数:%@",model.playcount];
    if ([model.source isEqualToString:@"国内"]) {
        cell.downLabel.text = [NSString stringWithFormat:@"已更新:%@",model.updated_playcount];
    }else{
        cell.downLabel.text = [NSString stringWithFormat:@"已译:%@",model.updated_playcount];
    }
    //    NSLog(@"cell.contentView.frame : %@",NSStringFromCGRect(cell.contentView.frame));
    //    NSLog(@"cell.titleLabel.frame : %@",NSStringFromCGRect(cell.titleLabel.frame));
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark -Search

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _dataList = [NSMutableArray array];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    for (AllCourseModel *model in delegate.allData) {
        if ([model.title containsString:searchBar.text]) {
            [_dataList addObject:model];
        }
    }
    [_tableView reloadData];
}

#pragma mark -UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allCourseCell" forIndexPath:indexPath];
    AllCourseModel *model = _dataList[indexPath.row];
    [self configCell:cell withModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AllCourseModel *model = _dataList[indexPath.row];
    PlayerViewController *playVC = [[PlayerViewController alloc] init];
    playVC.contentId = model.plid;
    [self rootNavigationPush:playVC];
}

@end
