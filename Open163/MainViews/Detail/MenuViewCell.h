//
//  MenuViewCell.h
//  Open163
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewCell : UICollectionViewCell

@property (nonatomic,assign) BOOL isForeign;

@property (nonatomic,assign) NSInteger numOfCourse;

- (void)setMenuData:(NSArray *)array;

@end
