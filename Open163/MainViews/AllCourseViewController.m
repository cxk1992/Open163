//
//  AllCourseViewController.m
//  Open163
//
//  Created by qianfeng on 15/8/19.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "AllCourseViewController.h"
#import "AllCourseModel.h"
#import "AllCourseTableViewCell.h"
#import "AppDelegate.h"

@interface AllCourseViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    NSMutableArray *_showArray;
    UIView *_selectView;
    UIButton *_btn;
    
    NSString *_typeSelect;
    NSString *_typeFrom;
    NSString *_typeHot;
}
@end

@implementation AllCourseViewController
{
    UIButton *_typeBtn;
    UIButton *_fromBtn;
    UIButton *_seqBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, screenWidth, screenheight - 95);
    [self initTableView];
    [self downloadData];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _typeSelect = @"全部";
    _typeFrom = @"全部";
    _typeHot = @"按最新";
    
    _selectView = [self headView];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 300)];
    [_tableView.tableHeaderView addSubview:_selectView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"AllCourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"allCourseCell"];
    [self.view addSubview:_tableView];
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0, 0, screenWidth, 30);
    _btn.alpha = 0.8;
    _btn.backgroundColor = [UIColor whiteColor];
    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btn.hidden = YES;
    _btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btn addTarget:self action:@selector(showSelectView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
}

- (UIView *)headView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 300)];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.9;
    
    NSArray *slArray = @[_typeSelect,_typeFrom,_typeHot];
    NSString *setString;
    NSArray *actions = @[@"typeAction:",@"fromAction:",@"sequence:"];
    NSInteger select = -1;
    NSArray *titleArray = @[
                            @[@"类型"],
                            @[@"全部",@"纪录片",@"文学",@"艺术"],
                            @[@"哲学",@"历史",@"经济",@"社会"],
                            @[@"法律",@"媒体",@"伦理",@"心理"],
                            @[@"管理",@"技能",@"数学",@"物理"],
                            @[@"化学",@"生物",@"医学",@"环境"],
                            @[@"计算机"],
                            @[@"来源"],
                            @[@"全部",@"国内",@"国外"],
                            @[@"TED",@"Coursera",@""],
                            @[@"按最新",@"按最热"]
                            ];
    for (NSInteger i=0; i<titleArray.count; i++) {
        CGFloat y = (300-10)/titleArray.count;
        NSArray *subTitles = titleArray[i];
        for (NSInteger j=0; j<subTitles.count; j++) {
            CGFloat x = (screenWidth - 20)/subTitles.count;
            NSString *title = subTitles[j];
            CGFloat width = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:subTitles[j] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.tag = 300+i*10+j;
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            if ([subTitles[j] isEqualToString:@"类型"]||[subTitles[j] isEqualToString:@"来源"]) {
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                select++;
                setString = slArray[select];
                goto add;
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_green_s_pressed"] forState:UIControlStateSelected];
            [btn addTarget:self action:NSSelectorFromString(actions[select]) forControlEvents:UIControlEventTouchUpInside];
            
            if ([setString isEqualToString:subTitles[j]]) {
                btn.selected = YES;
                switch (select) {
                    case 0:
                        _typeBtn = btn;
                        break;
                    case 1:
                        _fromBtn = btn;
                        break;
                    case 2:
                        _seqBtn = btn;
                        break;
                    default:
                        break;
                }
            }
            if ([subTitles[j] isEqualToString:@"Coursera"]) {
                select++;
                setString = slArray[select];
            }
            
            
            
        add:
            [view addSubview:btn];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(space)-[btn(width)]" options:0 metrics:@{@"space":@(20+x*j),@"width":@(width)} views:NSDictionaryOfVariableBindings(btn)]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(space)-[btn(20)]" options:0 metrics:@{@"space":@(10+y*i)} views:NSDictionaryOfVariableBindings(btn)]];
            
        }
    }

    return view;
}

- (void)downloadData{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.allData) {
        _dataArray = delegate.allData;
        [self updateData];
        return;
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:@"completeDownloadData" object:nil];
    }
}

- (void)getData:(NSNotification *)noti{
    if ([noti.object isKindOfClass:[NSArray class]]) {
        _dataArray = noti.object;
    }
    [self updateData];
}

- (void)updateData{
    [self selected];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView setContentOffset:CGPointMake(0, 0)];
    [_tableView.tableHeaderView addSubview:_selectView];
}

- (void)selected{
    _showArray = [NSMutableArray array];
    for (AllCourseModel *model in _dataArray) {
        if (!([model.source isEqualToString:_typeFrom]||[_typeFrom isEqualToString:@"全部"])) {
            continue;
        }
        if (!([model.tags containsString:_typeSelect]||[_typeSelect isEqualToString:@"全部"])) {
            continue;
        }
        [_showArray addObject:model];
    }
    if ([_typeHot isEqualToString:@"按最热"]) {
        [_showArray sortUsingSelector:@selector(comparesByHits:)];
    }
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

- (UIButton *)getButton:(NSString *)title{
    for (UIButton *btn in _selectView.subviews) {
        if ([btn.currentTitle isEqualToString:title]) {
            return btn;
        }
    }
    return nil;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -Actions

- (void)showSelectView{
    _btn.hidden = YES;
    CGRect frame = _selectView.frame;
    frame.origin.y = -300;
    _selectView.frame = frame;
    [self.view addSubview:_selectView];
    frame.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _selectView.frame = frame;
    }];
}

- (void)typeAction:(UIButton *)btn{
    if (_typeBtn == btn) {
        return;
    }
    _typeBtn.selected = NO;
    _typeBtn = btn;
    btn.selected = YES;
    _typeSelect = btn.currentTitle;
    
    [self updateData];
}

- (void)fromAction:(UIButton *)btn{
    if (_fromBtn == btn) {
        return;
    }
    _fromBtn.selected = NO;
    _fromBtn = btn;
    btn.selected = YES;
    _typeFrom = btn.currentTitle;
    
    [self updateData];
}

- (void)sequence:(UIButton *)btn{
    if (_seqBtn == btn) {
        return;
    }
    _seqBtn.selected = NO;
    _seqBtn = btn;
    _seqBtn.selected = YES;
    _typeHot = btn.currentTitle;
    
    [self updateData];
}




#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allCourseCell" forIndexPath:indexPath];
    AllCourseModel *model = _showArray[indexPath.row];
    [self configCell:cell withModel:model];
    if (indexPath.row == 0) {
        cell.selected = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y>300) {
        if (_btn.hidden) {
            _btn.hidden = NO;
            [_tableView.tableHeaderView addSubview:_selectView];
            [_btn setTitle:[NSString stringWithFormat:@"类型:%@ 来源:%@ %@",_typeSelect,_typeFrom,_typeHot] forState:UIControlStateNormal];
        }
    }else{
        if (!_btn.hidden) {
            _btn.hidden = YES;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AllCourseModel *model = _showArray[indexPath.row];
    PlayerViewController *playerVC = [[PlayerViewController alloc] init];
    playerVC.contentId = model.plid;
    [self rootNavigationPush:playerVC];
}


@end
