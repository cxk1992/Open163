//
//  DownloadViewCell.m
//  Open163
//
//  Created by 陈旭珂 on 15/10/15.
//  Copyright © 2015年 cxk. All rights reserved.
//

#import "DownloadViewCell.h"
#import "DownloadManager.h"
#import "DownloadListViewController.h"

@implementation DownloadViewCell
{
    UIProgressView *_progress;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 100, self.frame.size.height/2)];
    [self addSubview:_titleLabel];
    
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width - 100, self.frame.size.height/2)];
    [_progress setProgress:0.5];
    [self addSubview:_progress];
    
    self.downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadBtn.frame = CGRectMake(self.frame.size.width - 90, 5, 30, 30);
    self.downloadBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [self.downloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:self.downloadBtn];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(self.frame.size.width - 40, 5, 30, 30);
    [self.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:self.deleteBtn];
}

- (void)downloadAction:(UIButton *)btn{
    
}

- (void)deleteAction:(UIButton *)btn{
    [[DownloadManager shareManager] deleteMissionWithTitle:self.title andSubTitle:self.titleLabel.text];
    [self.delegate updateListView];
}

@end
