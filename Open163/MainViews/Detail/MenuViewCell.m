//
//  MenuViewCell.m
//  Open163
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "MenuViewCell.h"
#import "CourseModel.h"
#import "PlayerViewController.h"
#import "MenuSubCell.h"

@interface MenuViewCell () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation MenuViewCell
{
    UITableView *_tableView;
    NSArray *_dataArray;
    UILabel *_sourseLabel;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MenuSubCell" bundle:nil] forCellReuseIdentifier:@"menuSubCell"];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-100, 40)];
    label.text = @"已更新";
    _sourseLabel = label;
    [headView addSubview:label];
    _tableView.tableHeaderView = headView;
    [self addSubview:_tableView];
}

- (void)setIsForeign:(BOOL)isForeign{
    if (isForeign) {
        _sourseLabel.text = @"已翻译";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuSubCell" forIndexPath:indexPath];
    CourseModel *model = _dataArray[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"[第%li集]%@",indexPath.row+1,model.title];
    cell.titleLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == _numOfCourse) {
        cell.leftImageView.image = [UIImage imageNamed:@"ico_course_paly_pressed"];
    }else{
        cell.leftImageView.image = [UIImage imageNamed:@"ico_paly_circle"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)setMenuData:(NSArray *)array{
    _dataArray = array;
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionView *collection = (UICollectionView *)self.superview;
    PlayerViewController *VC = (PlayerViewController *)collection.delegate;
    VC.numOfCourse = indexPath.row;
    _numOfCourse = indexPath.row;
    [_tableView reloadData];
    [VC stopPlay];
    [VC startPlay];
}


@end
