//
//  MyButton.m
//  Open163
//
//  Created by qianfeng on 15/8/31.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton
{
    UIImage *_image;
    UIImage *_sImage;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 30, frame.size.height)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-30, (frame.size.height - 15)/2, 15, 15)];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.imageView.image = _sImage;
    }else{
        self.imageView.image = _image;
    }
}

- (void)setImage:(UIImage *)image andSelectedImage:(UIImage *)sImage{
    _image = image;
    _sImage = sImage;
    self.imageView.image = image;
}

@end
