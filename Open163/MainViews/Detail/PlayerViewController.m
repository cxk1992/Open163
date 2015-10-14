//
//  PlayerViewController.m
//  Open163
//
//  Created by qianfeng on 15/8/24.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "PlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CourseModel.h"
#import "IntroduceModel.h"
#import "AllCourseModel.h"
#import "IntroduceView.h"
#import "MenuViewCell.h"
#import "RecommendViewCell.h"
#import "CommentCollectionViewCell.h"
#import "DBManager.h"
#import "DownloadViewController.h"
#import <Social/Social.h>
#import "ReportViewController.h"


@interface PlayerViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
    MPMoviePlayerController *_moviePlayrer;
    
    NSMutableArray *_menuArray;
    UICollectionView *_collectionView;
    IntroduceModel *_thisModel;
    NSDictionary *_responseObject;
    
    UIView *_indictorView;
    UIView *_menuBgView;
    UIImageView *_loadAnimation;
}


@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    [self downloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initNav{
    UIImageView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 40)];
    navView.image = [UIImage imageNamed:@"bg_me_green"];
    [self.view addSubview:navView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.image = [UIImage imageNamed:@"ico_course_back"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 30, 80, 20);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [btn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [btn addSubview:imageView];
    [self.view addSubview:btn];
    
    NSArray *imageArray = @[@"loading1_iphone",@"loading2_iphone",@"loading3_iphone",@"loading4_iphone",@"loading5_iphone"];
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i=0; i<imageArray.count; i++) {
        UIImage *image = [UIImage imageNamed:imageArray[i]];
        [images addObject:image];
    }
    UIImage *image = images[0];
    _loadAnimation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    _loadAnimation.animationImages = images;
    _loadAnimation.animationRepeatCount = NSIntegerMax;
    _loadAnimation.animationDuration = 1;
    _loadAnimation.center = self.view.center;
    [self.view addSubview:_loadAnimation];
    [_loadAnimation startAnimating];
}

- (void)downloadData{
    if (!_contentId) {
        [_loadAnimation removeFromSuperview];
        [self createWebView];
        return;
    }
    NSArray *arr = [self.contentId componentsSeparatedByString:@"_"];
    self.contentId = arr[0];
    NSString *urlStr = [NSString stringWithFormat:kMovieUrl,self.contentId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json" , nil];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _menuArray = [NSMutableArray array];
        _thisModel = [[IntroduceModel alloc] init];
        [_thisModel setValuesForKeysWithDictionary:responseObject];
        for (NSDictionary *dic in responseObject[@"videoList"]) {
            CourseModel *model = [[CourseModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_menuArray addObject:model];
        }
        _responseObject = responseObject;
        [self createUI];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [_loadAnimation removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
    
}

- (void)createUI{
    [_loadAnimation removeFromSuperview];
    [self initRightBtn];
    [self createPlayer];
    [self createMenuView];
    [self createCollection];
}

- (void)createWebView{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.weburl]];
    [webView loadRequest:request];
}

- (void)initRightBtn{
    NSArray *icoArr = @[@"ico_course_favorites_iphone",@"ico_course_download_iphone",@"ico_course_share_iphone",@"ico_course_report_iphone"];
    NSArray *pressArr = @[@"ico_course_favorites_already_iphone",@"ico_course_download_press_iphone",@"ico_course_share_press_iphone",@"ico_course_report_press_iphone"];
    for (NSInteger i=0; i<icoArr.count; i++) {
        UIButton *icoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        icoBtn.frame = CGRectMake(screenWidth - 50 * (icoArr.count - i), 30, 20, 20);
        icoBtn.tag = 100+i;
        [icoBtn setBackgroundImage:[UIImage imageNamed:icoArr[i]] forState:UIControlStateNormal];
        [icoBtn setBackgroundImage:[UIImage imageNamed:pressArr[i]] forState:UIControlStateSelected];
        [icoBtn addTarget:self action:@selector(icoAction:) forControlEvents:UIControlEventTouchUpInside];
        if (!i) {
            icoBtn.selected = [[DBManager shareMnager] hasFavorites:_thisModel.plid];;
        }
        [self.view addSubview:icoBtn];
    }
}

- (void)createPlayer{
    CourseModel *model = _menuArray[0];
    _moviePlayrer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:model.repovideourlmp4]];
    _moviePlayrer.view.frame = CGRectMake(0, 60, screenWidth, 250);
    [self.view addSubview:_moviePlayrer.view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    imageView.center = _moviePlayrer.view.center;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPlay)];
    imageView.image = [UIImage imageNamed:@"ico_course_play"];
    imageView.userInteractionEnabled = YES;
    imageView.tag = 25;
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
}

- (void)createMenuView{
    NSArray *arr = @[@"简介",@"目录",@"相关推荐",@"跟帖"];
    _indictorView = [[UIView alloc]initWithFrame:CGRectMake(0, 28, screenWidth/arr.count, 2)];
    _indictorView.backgroundColor = [UIColor blackColor];
    _menuBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 310, screenWidth, 30)];
    [_menuBgView addSubview:_indictorView];
    for (NSInteger i=0; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i* screenWidth/arr.count, 0, screenWidth/arr.count, 28);
        [btn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 200+i;
        [_menuBgView addSubview:btn];
    }
    [self selectMenuBtn:0];
    [self.view addSubview:_menuBgView];
}

- (void)createCollection{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 340, screenWidth, screenheight - 340) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    
    [_collectionView registerClass:[IntroduceView class] forCellWithReuseIdentifier:@"introduceCell"];
    [_collectionView registerClass:[MenuViewCell class] forCellWithReuseIdentifier:@"menuCell"];
    [_collectionView registerClass:[RecommendViewCell class] forCellWithReuseIdentifier:@"recommendCell"];
    [_collectionView registerClass:[CommentCollectionViewCell class] forCellWithReuseIdentifier:@"commentCell"];
    
    [self.view addSubview:_collectionView];
}

- (void)startPlay{
    [[self.view viewWithTag:25] removeFromSuperview];
    CourseModel *model = _menuArray[_numOfCourse];
    _moviePlayrer.contentURL = [NSURL URLWithString:model.repovideourlmp4];
    [[DBManager shareMnager] insertHistoryWithPlid:_thisModel.plid andNumOfCourse:_numOfCourse];
    [_moviePlayrer prepareToPlay];
    [_moviePlayrer play];
}

- (void)stopPlay{
    [_moviePlayrer stop];
}

- (void)menuAction:(UIButton *)btn{
    CGFloat x = _collectionView.frame.size.width*btn.frame.origin.x/btn.frame.size.width;
    [_collectionView setContentOffset:CGPointMake(x, 0) animated:YES];
    [self selectMenuBtn:btn.tag-200];
}

- (void)selectMenuBtn:(NSInteger)tag{
    static UIButton *preBtn;
    preBtn.selected = NO;
    preBtn = (UIButton *)[_menuBgView viewWithTag:tag+200];
    preBtn.selected = YES;
}

- (void)icoAction:(UIButton *)btn{
    NSInteger tag = btn.tag-100;
    if (tag == 0) {
        if (btn.selected) {
            btn.selected ^= [[DBManager shareMnager] deleteFavoritesWithPlid:_thisModel.plid];
        }else{
            btn.selected ^= [[DBManager shareMnager] insertFavoritesWithPlid:_thisModel.plid];
        }
    } else if (tag == 1){
        DownloadViewController *downloadVC = [[DownloadViewController alloc] init];
        downloadVC.courses = _menuArray;
        downloadVC.courseTitle = _thisModel.title;
        downloadVC.courseData = _responseObject;
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [((UINavigationController *)delegate.window.rootViewController) pushViewController:downloadVC animated:YES];
    }else if (tag == 2){
        [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] ? NSLog(@"ok"):NSLog(@"fail");
        
//        SLComposeViewController *cc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTencentWeibo];
//        [cc setInitialText:@"分享至腾讯微博"];
//        
//        [self presentViewController:cc animated:YES completion:^{
//            
//        }];
        
        
    } else if (tag == 3){
        ReportViewController *vc = [[ReportViewController alloc] init];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [((UINavigationController *)delegate.window.rootViewController) pushViewController:vc animated:YES];
    }
    
}

- (void)popAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 0) {
        IntroduceView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"introduceCell" forIndexPath:indexPath];
        [cell setIntroduceWithModel:_thisModel];
        return cell;
    }else if(indexPath.item == 1){
        MenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuCell" forIndexPath:indexPath];
        cell.numOfCourse = _numOfCourse;
        if (![_thisModel.source isEqualToString:@"国内"]) {
            cell.isForeign = YES;
        }
        [cell setMenuData:[_menuArray copy]];
        return cell;
    }else if(indexPath.item == 2){
        RecommendViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendCell" forIndexPath:indexPath];
        [cell setTags:_thisModel.tags andSource:_thisModel.source andPlid:self.contentId];
        return cell;
    }else if (indexPath.item == 3){
        CommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"commentCell" forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(screenWidth, screenheight - 340);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect frame = _indictorView.frame;
    frame.origin.x = scrollView.contentOffset.x/4;
    _indictorView.frame = frame;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger tag = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self selectMenuBtn:tag];
}

#pragma mark - UIAlert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self popAction];
    }
}

@end
