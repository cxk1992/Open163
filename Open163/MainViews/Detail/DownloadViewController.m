//
//  DownloadViewController.m
//  Open163
//
//  Created by qianfeng on 15/8/31.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloadManager.h"
#import "MyButton.h"
#import "CourseModel.h"

@interface DownloadViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (nonatomic,assign) NSUInteger totalSize;

@end

@implementation DownloadViewController
{
    NSMutableArray *_downloadArray;
    NSMutableDictionary  *_downloadDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.totalSize = 0;
    _downloadArray = [NSMutableArray array];
    _downloadDict = [NSMutableDictionary dictionary];
}

- (void)createUI{
    CGFloat w = (screenWidth - 20*4)/3;
    CGFloat h = w*3/8;
    MyButton *btn;
    for (NSInteger i=0; i<[_courseData[@"videoList"] count]; i++) {
        NSInteger row = i/3;
        NSInteger col = i%3;
        btn = [[MyButton alloc] initWithFrame:CGRectMake(20+col*(w+20), 30+(h+20)*row, w, h)];
        btn.titleLabel.text = [NSString stringWithFormat:@"第%li集",i+1];
        [btn setImage:[UIImage imageNamed:@"check_box2"] andSelectedImage:[UIImage imageNamed:@"check_box2_selected"]];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.clipsToBounds = YES;
//        btn.backgroundColor = [UIColor orangeColor];
        [_scrollView addSubview:btn];
    }
    if ((btn.frame.origin.y+h)>_scrollView.frame.size.height) {
        _scrollView.contentSize = CGSizeMake(screenWidth, (btn.frame.origin.y + h));
    }else{
        _scrollView.contentSize = CGSizeMake(screenWidth, _scrollView.frame.size.height);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClicked:(MyButton *)btn{
    NSDictionary *dict = [_courseData[@"videoList"] objectAtIndex:btn.tag];
    NSString *title = [NSString stringWithFormat:@"[第%li集]%@",btn.tag+1,dict[@"title"]];
    if (btn.selected) {
        [_downloadDict removeObjectForKey:title];
        self.totalSize -= [dict[@"mp4size"] integerValue];
    }else{
        [_downloadDict setObject:dict forKey:title];
        self.totalSize += [dict[@"mp4size"] integerValue];
    }
    btn.selected ^= 1;
}

- (void)setTotalSize:(NSUInteger)totalSize{
    _totalSize = totalSize;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    self.sizeLabel.text = [NSString stringWithFormat:@"需要%liM,手机总空间%liG,剩余可用空间%liG",(_totalSize/1024/1024),([attributes[NSFileSystemSize] integerValue]/1024/1012/1024),[attributes[NSFileSystemFreeSize] integerValue]/1024/1024/1024];
}


- (IBAction)closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)downloadAction:(id)sender {
    [[DownloadManager shareManager] addDownloadMissionWithTitle:_courseData[@"title"] andDictionary:_downloadDict];
    [self closeAction:nil];
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}


@end
