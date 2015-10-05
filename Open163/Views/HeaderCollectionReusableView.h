//
//  HeaderCollectionReusableView.h
//  Open163
//
//  Created by qianfeng on 15/8/20.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UIImageView * bgImageView;

@end
