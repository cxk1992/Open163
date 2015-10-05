//
//  HomeCollectionViewCell.m
//  Open163
//
//  Created by qianfeng on 15/8/18.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HomeCollectionViewCell
{
    UIImageView *_imageView;
    UILabel *_descLabel;
    UILabel *_nameLabel;
    UILabel *_typeLabel;
}
- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_imageView];
        
        UIView *bgView = [[UIView alloc] init];
        _typeLabel = [[UILabel alloc] initWithFrame:bgView.bounds];
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _typeLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:_typeLabel];
        bgView.translatesAutoresizingMaskIntoConstraints = NO;
        bgView.alpha = 0.5;
        bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:bgView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_nameLabel];
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:10];
        _descLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _descLabel.textColor = [UIColor grayColor];
        [self addSubview:_descLabel];
        
        NSDictionary *dic = NSDictionaryOfVariableBindings(_imageView,_nameLabel,_typeLabel,_descLabel,bgView);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_imageView(_typeLabel,_nameLabel,_descLabel,bgView)]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:dic]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bgView(12)]-0-[_nameLabel(12)]-0-[_descLabel(12)]-0-|" options:0 metrics:nil views:dic]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-24-|" options:0 metrics:nil views:dic]];
    }
    return self;
}

- (void)setModel:(HomeCellModel *)model{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    _descLabel.text = model.description1;
    _nameLabel.text = model.title;
    _typeLabel.text = model.subtitle;
}


@end
