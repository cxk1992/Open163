//
//  DBManager.h
//  Open163
//
//  Created by qianfeng on 15/8/30.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBManager : NSObject

+ (DBManager *)shareMnager;

- (BOOL)insertFavoritesWithPlid:(NSString *)plid;
- (BOOL)hasFavorites:(NSString *)plid;
- (BOOL)deleteFavoritesWithPlid:(NSString *)plid;
- (NSArray *)selectAllFavorites;

- (BOOL)insertHistoryWithPlid:(NSString *)plid andNumOfCourse:(NSInteger)numOfCourse;
- (BOOL)deleteHistoryWithPlid:(NSString *)plid;
- (NSArray *)selectAllHistory;
@end
