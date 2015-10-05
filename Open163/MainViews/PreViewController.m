//
//  PreViewController.m
//  Open163
//
//  Created by qianfeng on 15/9/4.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "PreViewController.h"
#import "ScrollImage.h"

@interface PreViewController ()

@property (nonatomic,strong) backBlock backBlock;

@end

@implementation PreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self open];
}

- (void)startPlayWithDuration:(NSInteger)duration andBackBlock:(backBlock)block{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        block();
//    });
    _backBlock = block;
}

- (void)open{
    self.view.backgroundColor = [UIColor whiteColor];
    ScrollImage *scrollImageView = [[ScrollImage alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollImageView];
    scrollImageView.imageArray = @[[UIImage imageNamed:@"illustration00-Portrait"],[UIImage imageNamed:@"illustration01-Portrait"],[UIImage imageNamed:@"illustration02-Portrait"]];
    [scrollImageView addTapAction:^(NSInteger indexOfCurImg) {
        if (indexOfCurImg == 2) {
            _backBlock();
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
