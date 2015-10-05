//
//  HeaderCollectionReusableView.m
//  Open163
//
//  Created by qianfeng on 15/8/20.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 20)];
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 20, 20)];
        _bgImageView.image = [UIImage imageNamed:@"ico_course_play"];
        self.backgroundColor = [UIColor whiteColor];
        [self drawerLine];
        [self addSubview:self.nameLabel];
        [self addSubview:self.bgImageView];
    }
    return self;
}

- (void)drawerLine{
    UIBezierPath *bPath = [[UIBezierPath alloc] init];
    CGFloat x = self.bounds.size.width, y = self.bounds.size.height;
    [bPath moveToPoint:CGPointMake(0, y)];
    [bPath addLineToPoint:CGPointMake(x, y)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.lineWidth = 0.1;
    layer.strokeColor = [[UIColor blackColor] CGColor];
    layer.path = bPath.CGPath;
    [self.layer addSublayer:layer];
}

@end
