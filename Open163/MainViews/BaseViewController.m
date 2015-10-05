//
//  BaseViewController.m
//  Open163
//
//  Created by qianfeng on 15/8/17.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "SelectViewController.h"
#import "HistoryViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createNav{
    _navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 40)];
    _navView.userInteractionEnabled = YES;
    _navView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _navView.image = [UIImage imageNamed:@"bg_me_green"];
    [self.view addSubview:_navView];
    
    UIButton *icoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [icoBtn setBackgroundImage:[UIImage imageNamed:@"AppIcon60x60"] forState:UIControlStateNormal];
    icoBtn.frame = CGRectMake(10, 5, 30, 30);
    [_navView addSubview:icoBtn];
    
    NSArray *arr = @[@"历史",@"搜索"];
    for (NSInteger i=0; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(screenWidth - (arr.count - i)*50, 5, 30, 30);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(btnClickedOne:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:btn];
    }
}

- (void)btnClickedOne:(UIButton *)btn{
    if ([btn.currentTitle isEqualToString:@"搜索"]) {
        SelectViewController *selectVC = [[SelectViewController alloc] init];
        [self rootNavigationPush:selectVC];
    }else{
        HistoryViewController *hisVC = [[HistoryViewController alloc] init];
        hisVC.isHistory = YES;
        [self rootNavigationPush:hisVC];
    }
}

- (void)rootNavigationPush:(UIViewController *)viewController{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [((UINavigationController *)delegate.window.rootViewController) pushViewController:viewController animated:YES];
}

- (void)dealloc{
    
}

@end
