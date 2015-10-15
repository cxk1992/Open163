//
//  DownloadListViewController.m
//  Open163
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "DownloadListViewController.h"
#import "DownloadManager.h"
#import "DownloadViewCell.h"

@interface DownloadListViewController ()


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) NSDictionary * downloadList;

@property (nonatomic,strong) NSDictionary * completeList;

@property (nonatomic,assign) BOOL isDownlaod;

@property (nonatomic,strong) NSMutableDictionary * deleteDictionary;

@end

@implementation DownloadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
}

- (void)updateListView{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self getData];
}

- (void)getData{
    _downloadList = [[DownloadManager shareManager] downloadList];
    _completeList = [[DownloadManager shareManager] completeList];
    [self showDownloadList];
}

- (void)showDownloadList{
    CGFloat y = 0;
    CGFloat h = 44;
    NSArray *keys = _downloadList.allKeys;
    for (NSInteger i=0; i<keys.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, h)];
        y += h;
        label.text = keys[i];
        label.font = [UIFont systemFontOfSize:13];
        [self.scrollView addSubview:label];
        NSLog(@"%@",_downloadList[label.text]);
        for (NSInteger j=0; j<[_downloadList[keys[i]] count]; j++) {
            NSString *key = [_downloadList[keys[i]] allKeys][j];
            DownloadViewCell *view = [[DownloadViewCell alloc] initWithFrame:CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, h)];
            y += h;
            view.titleLabel.text = key;
            view.title = keys[i];
            view.delegate = self;
            [self.scrollView addSubview:view];
        }
    }
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, y + h);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
