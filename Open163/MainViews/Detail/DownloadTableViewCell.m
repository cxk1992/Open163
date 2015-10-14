//
//  DownloadTableViewCell.m
//  Open163
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "DownloadTableViewCell.h"
#import "DownloadManager.h"


@implementation DownloadTableViewCell
{
    NSURLConnection *_connection;
}

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)downloadAction:(id)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
