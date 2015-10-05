//
//  BaseViewController.h
//  Open163
//
//  Created by qianfeng on 15/8/17.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MyControl.h"
#import "UIImageView+WebCache.h"
#import "PlayerViewController.h"



@interface BaseViewController : UIViewController

@property (nonatomic,strong) UIImageView * navView;

- (void)createNav;

- (void)rootNavigationPush:(UIViewController *)viewController;


@end
