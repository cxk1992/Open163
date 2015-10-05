//
//  DownloadTableViewCell.h
//  Open163
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadTableViewCell : UITableViewCell

@property (nonatomic,strong) NSString * courseTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
