//
//  CollectionReusableView.m
//  Open163
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "IntroduceView.h"

@implementation IntroduceView
{
    UILabel *_nameLabel;
    UILabel *_sourceLabel;
    UILabel *_schoolLabel;
    UILabel *_directorLabel;
    UILabel *_introduceLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25)];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:_nameLabel];
    
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.frame.size.width, 20)];
    _sourceLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_sourceLabel];
    
    _schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, 20)];
    _schoolLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_schoolLabel];
    
    _directorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, self.frame.size.width, 20)];
    _directorLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_directorLabel];
    
    _introduceLabel = [[UILabel alloc] init];
    _introduceLabel.font = [UIFont systemFontOfSize:12];
    _introduceLabel.numberOfLines = 0;
    _introduceLabel.preferredMaxLayoutWidth = self.frame.size.width;
    _introduceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_introduceLabel];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-95-[_introduceLabel]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_introduceLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_introduceLabel(self)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_introduceLabel,self)]];
    
}

- (void)setIntroduceWithModel:(IntroduceModel *)model{
    _nameLabel.text = model.title;
    _sourceLabel.text = [@"类型: " stringByAppendingString:model.tags];
    _schoolLabel.text = [@"学校: " stringByAppendingString:model.school];
    _directorLabel.text = [@"讲师: " stringByAppendingString:model.director];
    _introduceLabel.text = [@"简介: " stringByAppendingString:model.description1];
}

@end
