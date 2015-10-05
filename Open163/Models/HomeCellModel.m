//
//  HomeCellModel.m
//  Open163
//
//  Created by qianfeng on 15/8/19.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "HomeCellModel.h"

@implementation HomeCellModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.description1 = value ;
    }else if ([key isEqualToString:@"id"]){
        self.id1 = value ;
    }
}


@end
