//
//  ScrollImage.m
//  ScrollImage
//
//  Created by qianfeng on 15/9/5.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "ScrollImage.h"

@interface ScrollImage ()

@property (nonatomic,strong) UIImageView * leftImageView;
@property (nonatomic,strong) UIImageView * centerImageView;
@property (nonatomic,strong) UIImageView * rightImageView;

@property (nonatomic,assign) CGRect leftFrame;
@property (nonatomic,assign) CGRect centerFrame;
@property (nonatomic,assign) CGRect rightFrame;

@property (nonatomic,assign) BOOL canScroll;

@property (nonatomic,strong) tapAction tapAction;

@end

@implementation ScrollImage
{
    BOOL _isMove;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configSelf];
    }
    return self;
}

- (void)configSelf{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _leftFrame = CGRectMake(-width/2, 0, width, height);
    _centerFrame = CGRectMake(0, 0, width, height);
    _rightFrame = CGRectMake(width/2, 0, width, height);
    
    _leftImageView = [[UIImageView alloc] initWithFrame:_leftFrame];
    _rightImageView = [[UIImageView alloc] initWithFrame:_rightFrame];
    _centerImageView = [[UIImageView alloc] initWithFrame:_centerFrame];
    [self addSubview:_leftImageView];
    [self addSubview:_rightImageView];
    [self addSubview:_centerImageView];
    _leftImageView.backgroundColor = [UIColor yellowColor];
    _centerImageView.backgroundColor = [UIColor grayColor];
    _rightImageView.backgroundColor = [UIColor orangeColor];
    
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    _currentImage = 0;
    _centerImageView.image = imageArray[0];
    if (imageArray.count == 1) {
        return;
    }
    _canScroll = YES;
    _leftImageView.image = imageArray[imageArray.count - 1];
    _rightImageView.image = imageArray[1];
}

- (void)addTapAction:(tapAction)tapAction{
    _tapAction = tapAction;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    _isMove = YES;
    if (!_canScroll) {
        return;
    }
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    CGPoint prePoint = [touch previousLocationInView:self];
    
    CGRect frame = _centerImageView.frame;
    frame.origin.x +=(point.x - prePoint.x);
    _centerImageView.frame = frame;
    
    frame = _leftImageView.frame;
    frame.origin.x +=(point.x - prePoint.x)/2;
    _leftImageView.frame = frame;
    
    frame = _rightImageView.frame;
    frame.origin.x +=(point.x - prePoint.x)/2;
    _rightImageView.frame = frame;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!_isMove) {
        _tapAction(_currentImage);
    }
    _isMove = NO;
    
    if (!_canScroll) {
        return;
    }
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    if (_centerImageView.center.x <= 0) {
        [UIView animateWithDuration:0.2 animations:^{
            _leftImageView.frame = CGRectMake(-width, 0, width, height);
            _centerImageView.frame = CGRectMake(-width, 0, width, height);
            _rightImageView.frame = CGRectMake(0, 0, width, height);
        } completion:^(BOOL finished) {
            _leftImageView.frame = _leftFrame;
            _centerImageView.frame = _centerFrame;
            _rightImageView.frame = _rightFrame;
            
            _currentImage++;
            if (_currentImage == _imageArray.count-1) {
                _centerImageView.image = _imageArray[_currentImage];
                _leftImageView.image = _imageArray[_currentImage - 1];
                _rightImageView.image = _imageArray[0];
            }else if (_currentImage == _imageArray.count){
                _currentImage = 0;
                _centerImageView.image = _imageArray[_currentImage];
                _leftImageView.image = _imageArray[_imageArray.count - 1];
                _rightImageView.image = _imageArray[_currentImage+1];
            }else{
                _centerImageView.image = _imageArray[_currentImage];
                _leftImageView.image = _imageArray[_currentImage-1];
                _rightImageView.image = _imageArray[_currentImage+1];
            }
        }];
    }else if (_centerImageView.center.x >= self.bounds.size.width){
        [UIView animateWithDuration:0.2 animations:^{
            _rightImageView.frame = CGRectMake(width, 0, width, height);
            _centerImageView.frame = CGRectMake(width, 0, width, height);
            _leftImageView.frame = CGRectMake(0, 0, width, height);
        } completion:^(BOOL finished) {
            _leftImageView.frame = _leftFrame;
            _centerImageView.frame = _centerFrame;
            _rightImageView.frame = _rightFrame;
            
            _currentImage--;
            if (_currentImage == 0) {
                _centerImageView.image = _imageArray[_currentImage];
                _leftImageView.image = _imageArray[_imageArray.count - 1];
                _rightImageView.image = _imageArray[_currentImage+1];
            }else if (_currentImage == -1){
                _currentImage = _imageArray.count - 1;
                _centerImageView.image = _imageArray[_currentImage];
                _leftImageView.image = _imageArray[_currentImage - 1];
                _rightImageView.image = _imageArray[0];
            }else{
                _centerImageView.image = _imageArray[_currentImage];
                _leftImageView.image = _imageArray[_currentImage-1];
                _rightImageView.image = _imageArray[_currentImage+1];
            }
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            _leftImageView.frame = _leftFrame;
            _centerImageView.frame = _centerFrame;
            _rightImageView.frame = _rightFrame;
        }];
    }
}


@end
