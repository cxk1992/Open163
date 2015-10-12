//
//  ScrollCollectionViewCell.m
//  Open163
//
//  Created by qianfeng on 15/8/21.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "ScrollCollectionViewCell.h"

@interface ScrollCollectionViewCell () <UIScrollViewDelegate>

@end

@implementation ScrollCollectionViewCell
{
    NSTimer *_timer;
}

- (void)awakeFromNib {
    [self initAtFirst];
}

- (void)initAtFirst{
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.titleArray = [NSMutableArray array];
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scroll) userInfo:nil repeats:NO];
}

- (void)scroll{
    UIScrollView *ss = self.scrollView;
    CGPoint offset = ss.contentOffset;
    NSInteger index = offset.x/ss.bounds.size.width;
    if (index<self.titleArray.count-1) {
        offset.x += ss.bounds.size.width;
    }else{
        offset.x = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        ss.contentOffset = offset;
    }];
    [self scrollViewDidEndDecelerating:self.scrollView];
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
//    if (index == 0) {
//        index = _titleArray.count-1;
//        [scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*(index+1), 0) animated:NO];
//    }else if (index == _titleArray.count){
//        index = 0;
//        [scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*(index+1), 0) animated:NO];
//    }
    self.pageControl.currentPage = index;
    self.titleLabel.text = self.titleArray[index];
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scroll) userInfo:nil repeats:NO];
}




@end
