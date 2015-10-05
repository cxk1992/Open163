//
//  PreViewController.h
//  Open163
//
//  Created by qianfeng on 15/9/4.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backBlock)();

@interface PreViewController : UIViewController

- (void)startPlayWithDuration:(NSInteger)duration andBackBlock:(backBlock)block;

@end
