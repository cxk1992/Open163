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
#import <MediaPlayer/MediaPlayer.h>


@interface DownloadViewCell () <UIAlertViewDelegate>

@end

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
    [_progress setProgress:0];
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
    if ([btn.currentTitle isEqualToString:@"下载"]) {
        if ([[DownloadManager shareManager] allowToDownload]) {
            NSString *filePath = [[[DownloadManager shareManager] downloadPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.mp4",self.title,self.titleLabel.text]];
            Downloader *downloader = [[Downloader alloc] init];
            
            downloader.delegate = self;
            
            [downloader downloadWithURLString:self.urlString andPath:filePath successBlock:^(NSData *receiveData) {
                
            } failBlock:^(NSString *filePath, NSString *urlString) {
                
            } response:^(NSURLResponse *response) {
                
            } saveData:^(float f) {
                
            }];
            [self.downloadBtn setTitle:@"取消" forState:UIControlStateNormal];
            
        }else{
            
        }
    }else if([btn.currentTitle isEqualToString:@"取消"]){
        [btn setTitle:@"下载" forState:UIControlStateNormal];
        Downloader *downloader = [[DownloadManager shareManager] getDownloaderWithUrlstring:self.urlString];
        [downloader stopDownload];
    }else if ([btn.currentTitle isEqualToString:@"播放"]){
        NSString *filePath = [[[DownloadManager shareManager] downloadPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.mp4",self.title,self.titleLabel.text]];
        MPMoviePlayerViewController *plyerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
        [self.delegate presentViewController:plyerVC animated:NO completion:nil];
    }
}

- (void)deleteAction:(UIButton *)btn{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除下载任务" message:@"确定要删除任务及文件吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)dealloc{
    
}

#pragma mark - downloadDelegate

- (void)downloadChangeDatalength:(float)f{
    [_progress setProgress:f];
}

- (void)downloadSuccess:(NSData *)receiveData{
    [[DownloadManager shareManager] completeDownloadMissionWithTitle:self.title andSubtitle:self.titleLabel.text urlstring:self.urlString];
    [self.delegate updateListView];
}

#pragma mark alertdelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [[DownloadManager shareManager] deleteMissionWithTitle:self.title andSubTitle:self.titleLabel.text];
        [self.delegate updateListView];
    }
}

@end
