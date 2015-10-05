//
//  AllCourseModel.m
//  Open163
//
//  Created by qianfeng on 15/8/22.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "AllCourseModel.h"

@implementation AllCourseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.description1 = value;
    }else{
        NSLog(@"%@未找到",key);
    }
}

- (BOOL)comparesByHits:(AllCourseModel *)model{
    if ([model.hits integerValue]>[self.hits integerValue]) {
        return YES;
    }
    return NO;
}

@end
