//
//  HistoryViewController.m
//  Open163
//
//  Created by qianfeng on 15/8/30.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "HistoryViewController.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "AllCourseModel.h"
#import "AllCourseTableViewCell.h"
#import "PlayerViewController.h"

@interface HistoryViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataList;
    NSMutableArray *_deleteList;
    NSMutableArray *_historyArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *hidenView;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configTableView{
    if (_isHistory) {
        _titleLabel.text = @"播放历史";
    }
    [_tableView registerNib:[UINib nibWithNibName:@"AllCourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"allCourseCell"];
}

- (void)getData{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (!(delegate.allData)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"completeDownloadData" object:nil];
        return;
    }
    _dataList = [NSMutableArray array];
    NSMutableArray *data;
    if (_isHistory) {
        _historyArray = [[[DBManager shareMnager] selectAllHistory] mutableCopy];
        data = [NSMutableArray array];
        for (NSDictionary *dict in _historyArray) {
            [data addObject:dict[@"plid"]];
        }
    }else{
        data= [[[DBManager shareMnager] selectAllFavorites] mutableCopy];
    }
    for (NSString *plid in data) {
        for (AllCourseModel *model in delegate.allData) {
            if ([model.plid isEqualToString:plid]) {
                [_dataList addObject:model];
                break;
            }
        }
    }
    [_tableView reloadData];
}

- (void)configCell:(AllCourseTableViewCell *)cell withModel:(AllCourseModel *)model indexPath:(NSIndexPath *)indexPath{
    [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.largeimgurl]];
    cell.titleLabel.text = model.title;
    if (_isHistory) {
        cell.typeLabel.text = [NSString stringWithFormat:@"已看至第%li集",[_historyArray[indexPath.row][@"numOfCourse"] integerValue] + 1];
    }else{
        cell.typeLabel.text = [NSString stringWithFormat:@"分类:%@",model.tags];
    }
    cell.leftBottomLabel.text = [NSString stringWithFormat:@"集数:%@",model.playcount];
    if ([model.source isEqualToString:@"国内"]) {
        cell.downLabel.text = [NSString stringWithFormat:@"已更新:%@",model.updated_playcount];
    }else{
        cell.downLabel.text = [NSString stringWithFormat:@"已译:%@",model.updated_playcount];
    }
    //    NSLog(@"cell.contentView.frame : %@",NSStringFromCGRect(cell.contentView.frame));
    //    NSLog(@"cell.titleLabel.frame : %@",NSStringFromCGRect(cell.titleLabel.frame));
}

- (IBAction)editAction:(id)sender {
    UIButton *btn = sender;
    if ([btn.currentTitle isEqualToString:@"编辑"]) {
        [_tableView setEditing:YES animated:YES];
        _deleteList = [NSMutableArray array];
        _hidenView.hidden = NO;
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [_tableView setEditing:NO animated:YES];
        _deleteList = nil;
        _hidenView.hidden = YES;
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)allSelectAction:(id)sender {
    UIButton *btn = sender;
    if ([btn.currentTitle isEqualToString:@"全选"]) {
        for (NSInteger i=0; i<_dataList.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
        }
        [btn setTitle:@"取消全选" forState:UIControlStateNormal];
    }else{
        for (NSInteger i=0; i<_dataList.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self tableView:_tableView didDeselectRowAtIndexPath:indexPath];
        }
        [btn setTitle:@"全选" forState:UIControlStateNormal];
    }
}

- (IBAction)deleteAction:(id)sender {
    if (_isHistory) {
        for (AllCourseModel *model in _deleteList) {
            [_dataList removeObject:model];
            if (![[DBManager shareMnager] deleteHistoryWithPlid:model.plid]) {
                NSLog(@"%@未删除成功",model.title);
            }
        }
    }else{
        for (AllCourseModel *model in _deleteList) {
            [_dataList removeObject:model];
            if (![[DBManager shareMnager] deleteFavoritesWithPlid:model.plid]) {
                NSLog(@"%@未删除成功",model.title);
            }
        }
    }
    [_allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [_tableView reloadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allCourseCell" forIndexPath:indexPath];
    AllCourseModel *model = _dataList[indexPath.row];
    [self configCell:cell withModel:model indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        AllCourseModel *model = _dataList[indexPath.row];
        [_deleteList removeObject:model];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        AllCourseModel *model = _dataList[indexPath.row];
        [_deleteList addObject:model];
    }else{
        AllCourseModel *model = _dataList[indexPath.row];
        PlayerViewController *playerVC = [[PlayerViewController alloc] init];
        playerVC.contentId = model.plid;
        if (_isHistory) {
            playerVC.numOfCourse = [_historyArray[indexPath.row][@"numOfCourse"] integerValue];
        }
        [self.navigationController pushViewController:playerVC animated:YES];
    }
}


@end
