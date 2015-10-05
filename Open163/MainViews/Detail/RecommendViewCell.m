//
//  RecommendViewCell.m
//  Open163
//
//  Created by qianfeng on 15/8/26.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "RecommendViewCell.h"
#import "AppDelegate.h"
#import "AllCourseTableViewCell.h"
#import "AllCourseModel.h"
#import "UIImageView+WebCache.h"
#import "PlayerViewController.h"

@interface RecommendViewCell () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation RecommendViewCell
{
    NSMutableArray *_showArray;
    UITableView *_tableView;
    
    NSString *_tags;
    NSString *_source;
    NSString *_plid;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createTableView];
    }
    return self;
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"AllCourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"allCourseCell"];
    
    [self addSubview:_tableView];
}

- (void)setTags:(NSString *)tags andSource:(NSString *)source andPlid:(NSString *)plid{
    _tags = tags;
    _source = source;
    _plid = plid;
    [self getData];
}

- (void)getData{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.allData) {
        NSArray *array = [delegate.allData copy];
        NSNotification *noti = [NSNotification notificationWithName:@"completeDownloadData" object:array];
        [self selectData:noti];
        
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectData:) name:@"completeDownloadData" object:nil];
    }
    
}

- (void)selectData:(NSNotification *)noti{
    if ([noti.object isKindOfClass:[NSArray class]]) {
        _showArray = [NSMutableArray array];
        NSArray *array = [_tags componentsSeparatedByString:@","];
        for (AllCourseModel *model in noti.object) {
            if (![model.source isEqualToString:_source]) {
                continue;
            }
            if ([model.plid isEqualToString:_plid]) {
                continue;
            }
            for (NSString *str in array) {
                if ([model.tags containsString:str]) {
                    [_showArray addObject:model];
                    break;
                }
            }
        }
    }
    [_tableView reloadData];
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

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allCourseCell" forIndexPath:indexPath];
    AllCourseModel *model = _showArray[indexPath.row];
    [self configCell:cell withModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionView *collection = (UICollectionView *)self.superview;
    PlayerViewController *thisPlayer = (PlayerViewController *)collection.delegate;
    [thisPlayer stopPlay];
    
    AllCourseModel *model = _showArray[indexPath.row];
    PlayerViewController *playerVC = [[PlayerViewController alloc] init];
    playerVC.contentId = model.plid;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [((UINavigationController *)delegate.window.rootViewController) pushViewController:playerVC animated:YES];
}


@end
