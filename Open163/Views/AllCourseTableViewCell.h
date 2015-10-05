//
//  AllCourseTableViewCell.h
//  Open163
//
//  Created by qianfeng on 15/8/22.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllCourseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;

@end
