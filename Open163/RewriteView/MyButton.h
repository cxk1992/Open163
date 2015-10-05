//
//  MyButton.h
//  Open163
//
//  Created by qianfeng on 15/8/31.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIControl

@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIImageView * imageView;

- (void)setImage:(UIImage *)image andSelectedImage:(UIImage *)sImage;

@end
