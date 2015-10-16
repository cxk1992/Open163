//
//  DownloadManager.h
//  Open163
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^success)(NSData *receiveData);
typedef void(^fail)(NSString *filePath,NSString *urlString);
typedef void(^getResponse)(NSURLResponse *response);
typedef void(^saveData)(float f);

@class Downloader;
@interface DownloadManager : NSObject



@property (nonatomic,strong,readonly) NSString * downloadPath;

+ (DownloadManager *)shareManager;

- (void)addDownloadMissionWithTitle:(NSString *)title andDictionary:(NSDictionary *)dict;

- (BOOL)deleteMissionWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle;

- (void)completeDownloadMissionWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle urlstring:(NSString *)urlstring;

- (void)startADownloadMissionWithUrlstring:(NSString *)urlstring andDownloader:(Downloader *)downloader;

- (void)cancelADownloadMissionWithUrlString:(NSString *)urlString;

- (Downloader *)getDownloaderWithUrlstring:(NSString *)urlString;

- (BOOL)allowToDownload;

- (NSDictionary *)downloadList;

- (NSDictionary *)completeList;

@end

@protocol DownloadDelegat <NSObject>

- (void)downloadSuccess:(NSData *)receiveData;

- (void)downloadChangeDatalength:(float)f;

@end

@interface Downloader : NSObject

@property (nonatomic,strong) success successBlock;
@property (nonatomic,strong) fail failBlock;
@property (nonatomic,strong) getResponse responseBlock;
@property (nonatomic,strong) saveData saveBlock;

@property (nonatomic,weak) id <DownloadDelegat> delegate;

- (void)downloadWithURLString:(NSString *)urlString andPath:(NSString *)filePath successBlock:(success)successBlock failBlock:(fail)failureBlock response:(getResponse)responseBlock saveData:(saveData)saveBlock;

- (void)startDownload;

- (void)stopDownload;

@end