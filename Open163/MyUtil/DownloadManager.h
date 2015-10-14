//
//  DownloadManager.h
//  Open163
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^success)(NSString *filePath,NSString *urlString);
typedef void(^fail)(NSString *filePath,NSString *urlString);
typedef void(^getResponse)(NSURLResponse *response);

@interface DownloadManager : NSObject

+ (DownloadManager *)shareManager;

- (void)addDownloadMissionWithTitle:(NSString *)title andDictionary:(NSDictionary *)dict;

- (BOOL)deleteMissionWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle;

- (void)startDownloadWithTitle:(NSString *)title andCourseName:(NSString *)courseName;

- (NSDictionary *)downloadList;

- (NSDictionary *)completeList;

@end



@interface Downloader : NSObject

@property (nonatomic,strong) success successBlock;
@property (nonatomic,strong) fail failBlock;
@property (nonatomic,strong) getResponse responseBlock;

- (void)downloadWithURLString:(NSString *)urlString andPath:(NSString *)filePath successBlock:(success)successBlock failBlock:(fail)failureBlock response:(getResponse)responseBlock;

- (void)startDownload;

- (void)stopDownload;

@end