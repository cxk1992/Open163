//
//  ScrollImage.h
//  ScrollImage
//
//  Created by qianfeng on 15/9/5.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapAction)(NSInteger indexOfCurImg);

@interface ScrollImage : UIView

@property (nonatomic,copy) NSArray * imageArray;
@property (nonatomic,assign) NSInteger currentImage;

- (void)addTapAction:(tapAction)tapAction;

@end
