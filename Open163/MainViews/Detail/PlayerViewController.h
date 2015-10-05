//
//  PlayerViewController.h
//  Open163
//
//  Created by qianfeng on 15/8/24.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MyControl.h"
#import "UIImageView+WebCache.h"
#import "BaseViewController.h"
#import "AppDelegate.h"

@interface PlayerViewController : UIViewController

@property (nonatomic,strong) NSString * contentId;

@property (nonatomic,strong) NSString * weburl;

@property (nonatomic,assign) NSInteger numOfCourse;

- (void)startPlay;

- (void)stopPlay;

@end
