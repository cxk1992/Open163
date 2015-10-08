//
//  HomeViewController.m
//  Open163
//
//  Created by qianfeng on 15/8/19.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "HomeCellModel.h"
#import "HeaderCollectionReusableView.h"
#import "ScrollCollectionViewCell.h"

@interface HomeViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
    
    UILabel *_refreshLabel;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = self.view.bounds;
    frame.origin.y = 95;
    frame.size.height -=95;
    self.view.frame = frame;
    [self initCollectionView];
    [self downloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCollectionView{
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//    layout.itemSize = CGSizeMake((screenWidth-15)/2, 100);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [_collectionView registerClass:[HomeCollectionViewCell class]forCellWithReuseIdentifier:@"HomeCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"ScrollCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"adCell"];
//    [_collectionView registerNib:[UINib nibWithNibName:@"HeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];
    [_collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    _refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 30)];
    _refreshLabel.text = @"准备加载";
    _refreshLabel.textAlignment = NSTextAlignmentCenter;
    _refreshLabel.textColor = [UIColor blackColor];
    [_collectionView addSubview:_refreshLabel];
}

- (void)downloadData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:kHomeUrlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _dataArray = [NSMutableArray array];
        for (NSDictionary *dict in responseObject) {
            NSArray *arr = dict[@"vos"];
            NSMutableArray *cellArray = [NSMutableArray array];
            for (NSDictionary *cellDic in arr) {
                HomeCellModel *model = [[HomeCellModel alloc] init];
                [model setValuesForKeysWithDictionary:cellDic];
                [cellArray addObject:model];
            }
            NSMutableDictionary *sectionDic = [NSMutableDictionary dictionaryWithDictionary:dict];
            [sectionDic setObject:cellArray forKey:@"vos"];
            [_dataArray addObject:sectionDic];
        }
        [_collectionView reloadData];
        [self endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [self endRefresh];
    }];
}

- (void)beginRefresh{
    NSLog(@"%s",__FUNCTION__);
    _collectionView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    _refreshLabel.text = @"正在刷新";
    [self downloadData];
}

-(void)endRefresh{
    NSLog(@"%s",__FUNCTION__);
    _refreshLabel.text = @"刷新完成";
    [UIView animateWithDuration:0.3 animations:^{
        _collectionView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _refreshLabel.text = @"准备加载";
    }];
}

- (void)configAdCell:(ScrollCollectionViewCell *)cell indexpath:(NSIndexPath *)indexpath{
    if (cell.showed) {
        return;
    }
    cell.showed = YES;
    CGFloat width = cell.scrollView.bounds.size.width;
    NSArray *arr = _dataArray[indexpath.section][@"vos"];
    NSInteger count = arr.count;
    for (NSInteger i=0; i<count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*i, 0, width, cell.scrollView.frame.size.height)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
        [imageView addGestureRecognizer:tap];
        imageView.tag = i+100;
        imageView.userInteractionEnabled = YES;
        [cell.scrollView addSubview:imageView];
        HomeCellModel *model = arr[i];
        [cell.titleArray addObject:model.title];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    }
    cell.scrollView.contentSize = CGSizeMake(width*count, cell.scrollView.bounds.size.height);
    cell.pageControl.numberOfPages = count;
    cell.pageControl.currentPage = 0;
    cell.titleLabel.text = [cell.titleArray firstObject];;
}

- (void)imageViewTapAction:(UITapGestureRecognizer *)tap{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:tap.view.tag-100 inSection:0];
    [self collectionView:_collectionView didSelectItemAtIndexPath:indexPath];
}

- (void)dealloc{
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    NSDictionary *dic = _dataArray[section];
    NSArray *arr = dic[@"vos"];
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.section) {
        ScrollCollectionViewCell *adCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"adCell" forIndexPath:indexPath];
        [self configAdCell:adCell indexpath:indexPath];
        return adCell;
    }
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    NSDictionary *dic = _dataArray[indexPath.section];
    NSArray *arr = dic[@"vos"];
    HomeCellModel *model = arr[indexPath.item];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(self.view.bounds.size.width, 0);;
    }
    return CGSizeMake(self.view.bounds.size.width, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(collectionView.frame.size.width -10, 200);
    }
    else if(indexPath.section == 2){
        return CGSizeMake((screenWidth-15)/2, 150);
    }
    return CGSizeMake((screenWidth-15)/2, 100);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headCell" forIndexPath:indexPath];
        view.nameLabel.text = _dataArray[indexPath.section][@"name"];
        return view;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCellModel *model = _dataArray[indexPath.section][@"vos"][indexPath.item];
    PlayerViewController *playerVC = [[PlayerViewController alloc] init];
    playerVC.contentId = model.contentId;
    playerVC.weburl = model.contentUrl;
    [self rootNavigationPush:playerVC];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y<-80) {
        [self beginRefresh];
    }
}




@end
