//
//  DBManager.m
//  Open163
//
//  Created by qianfeng on 15/8/30.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
{
    FMDatabase *_dataBase;
}
+ (DBManager *)shareMnager{
    static DBManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        
        NSString *path=[NSHomeDirectory() stringByAppendingString:@"/Documents/user.db"];
        _dataBase = [[FMDatabase alloc] initWithPath:path];
        if ([_dataBase open]) {
            NSString *favoritesSql = @"create table if not exists favorites (plid varchar(100) primary key)";
            BOOL success = [_dataBase executeUpdate:favoritesSql];
            if (!success) {
                NSLog(@"%@",_dataBase.lastError.localizedDescription);
            }
            NSString *historySql = @"create table if not exists history (plid varchar(100) primary key,numOfCourse integer)";
            success = [_dataBase executeUpdate:historySql];
            if (!success) {
                NSLog(@"%@",_dataBase.lastError.localizedDescription);
            }
        }
        
    }
    return self;
}

- (BOOL)insertFavoritesWithPlid:(NSString *)plid{

    NSString *insertSql = @"insert into favorites(plid) values(?)";
    BOOL success = [_dataBase executeUpdate:insertSql,plid];
    if (!success) {
        NSLog(@"%@",_dataBase.lastError.localizedDescription);
    }
    return success;
}
- (BOOL)hasFavorites:(NSString *)plid{
    NSString *selectSql = @"select * from favorites where plid = ?";
    FMResultSet *set = [_dataBase executeQuery:selectSql,plid];
    if ([set next]) {
        [set close];
        return YES;
    }
    [set close];
    return NO;
}
- (BOOL)deleteFavoritesWithPlid:(NSString *)plid{
  
    NSString *deleteSql = @"delete from favorites where plid = ?";
    BOOL success = [_dataBase executeUpdate:deleteSql,plid];
  
    if (!success) {
        NSLog(@"%@",_dataBase.lastError.localizedDescription);
    }
    return success;
}
- (NSArray *)selectAllFavorites{
    NSString *sql = @"select * from favorites";
    FMResultSet *set = [_dataBase executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        NSString *plid = [set stringForColumn:@"plid"];
        [array addObject:plid];
    }
    [set close];
    return [array copy];
}

- (BOOL)insertHistoryWithPlid:(NSString *)plid andNumOfCourse:(NSInteger)numOfCourse{
    NSString *searchSql = @"select * from history where plid = ?";
    BOOL success = [[_dataBase executeQuery:searchSql,plid] next];
    if (success) {
        NSString *updateSql = @"update history set numOfCourse = ? where plid = ?";
        return [_dataBase executeUpdate:updateSql,@(numOfCourse),plid];
    }else{
        NSString *insertSql = @"insert into history(plid,numOfCourse) values(?,?)";
        return [_dataBase executeUpdate:insertSql,plid,@(numOfCourse)];
    }
}
- (BOOL)deleteHistoryWithPlid:(NSString *)plid{
    NSString *sql = @"delete from history where plid = ?";
    return [_dataBase executeUpdate:sql,plid];
}
- (NSArray *)selectAllHistory{
    NSString *sql = @"select * from history";
    FMResultSet *set = [_dataBase executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        NSString *plid = [set stringForColumn:@"plid"];
        NSInteger numOfCourse = [set intForColumn:@"numOfCourse"];
        [array addObject:@{@"plid":plid,@"numOfCourse":@(numOfCourse)}];
    }
    return [array copy];
}

@end
