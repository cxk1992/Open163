//
//  MainViewController.m
//  Open163
//
//  Created by qianfeng on 15/8/16.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "MainViewController.h"
#import "EventView.h"
#import "AllCourseModel.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>


@interface MainViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    
    NSMutableArray *_viewsArray;
    UISegmentedControl *_titleSegment;
    UIPageViewController *_pageVC;
    UIScrollView *_scrollViewInPage;
    UIView *_indicatorView;
    
    NSInteger _currentPage;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self initViews];
    [self createUI];
    [self downloadData];
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 100;
    [_locationManager startUpdatingLocation];
    
    NSLog(@"%@",NSHomeDirectory());
}

- (void)createUI{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 60, screenWidth, 35)];
    [self.view addSubview:view];
    NSArray *arr = @[@"首页",@"全部课程",@"我"];
    for (NSInteger i=0; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * (screenWidth)/arr.count , 2, screenWidth/arr.count, 30);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 32, screenWidth/arr.count, 2)];
    _indicatorView.backgroundColor = [UIColor grayColor];
    [view addSubview:_indicatorView];
    
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    [_pageVC setViewControllers:@[_viewsArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self.view addSubview:_pageVC.view];
    _currentPage = 0;
    _pageVC.view.frame = CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height-95);
    
    for (UIView *view in [_pageVC.view subviews]) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            _scrollViewInPage = (UIScrollView *)view;
            _scrollViewInPage.delegate = self;
        }
    }
}

- (void)downloadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:kAllCourseUrlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *  dataArray = [NSMutableArray array];
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in responseObject) {
            AllCourseModel *model = [[AllCourseModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            if ([muArray containsObject:model.plid]) {
                continue;
            }
            [muArray addObject:model.plid];
            [dataArray addObject:model];
        }
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.allData = [dataArray copy];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"completeDownloadData" object:delegate.allData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)initViews{
    _viewsArray = [NSMutableArray array];
    NSArray *arr = @[@"HomeViewController",@"AllCourseViewController",@"MineViewController"];
    for (NSInteger i=0; i<arr.count; i++) {
        Class cls = NSClassFromString(arr[i]);
        UIViewController *viewController = [[cls alloc] init];
        [_viewsArray addObject:viewController];
    }
}

- (void)btnClicked:(UIButton *)btn{
    NSInteger tag = btn.tag-100;
    if (_currentPage == tag) {
        return;
    }
    __weak typeof(self) wSelf = self;
    [_pageVC setViewControllers:@[_viewsArray[tag]] direction:tag<_currentPage animated:YES completion:^(BOOL finish){
        _currentPage = tag;
        [wSelf adjustIndicatorView];
    }];
}

- (void)adjustIndicatorView{
    CGRect frame = _indicatorView.frame;
    frame.origin.x = self.view.frame.size.width*_currentPage/3;
    _indicatorView.frame = frame;
}

- (void)dealloc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch");
}

#pragma mark ------UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

#pragma mark --UIPageViewController

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if (_currentPage+1 == _viewsArray.count) {
        
        
        return nil;
    }
    return _viewsArray[_currentPage+1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if (_currentPage == 0) {
        return nil;
    }
    return _viewsArray[_currentPage-1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    _currentPage = [_viewsArray indexOfObject:_pageVC.viewControllers[0]];
    [self adjustIndicatorView];
    
}

#pragma mark locationDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [_locationManager stopUpdatingLocation];
    NSLog(@"%@",locations);
}



@end
