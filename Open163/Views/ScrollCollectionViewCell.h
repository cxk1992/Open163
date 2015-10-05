//
//  ScrollCollectionViewCell.h
//  Open163
//
//  Created by qianfeng on 15/8/21.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollCollectionViewCell : UICollectionViewCell

@property (nonatomic,assign) BOOL showed;
@property (nonatomic,strong) NSMutableArray * titleArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
