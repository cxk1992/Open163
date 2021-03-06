//
//  DownloadViewCell.h
//  Open163
//
//  Created by 陈旭珂 on 15/10/15.
//  Copyright © 2015年 cxk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadListViewController.h"
#import "DownloadManager.h"

@interface DownloadViewCell : UIView <DownloadDelegat>

@property (nonatomic,weak) DownloadListViewController *delegate;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *urlString;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *downloadBtn;

@property (nonatomic,strong) UIButton *deleteBtn;

@end
