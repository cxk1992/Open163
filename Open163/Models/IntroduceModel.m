//
//  IntroduceModel.m
//  Open163
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "IntroduceModel.h"

@implementation IntroduceModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.description1 = value;
    }
}

@end
