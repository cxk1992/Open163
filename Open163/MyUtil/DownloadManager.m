//
//  DownloadManager.m
//  Open163
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "DownloadManager.h"


@interface DownloadManager ()



@property (nonatomic,strong) NSMutableDictionary * downloadInfo;

@end

@implementation DownloadManager
{
    NSFileManager *_fileManager;
    NSMutableDictionary *_downloadingDic;
    
    NSInteger _downloadCount;
}

- (instancetype)init{
    if (self = [super init]) {
        _downloadPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Download"];
        [self prepareForDownload];
    }
    return self;
}

+ (DownloadManager *)shareManager{
    static DownloadManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownloadManager alloc] init];
    });
    return manager;
}

- (void)prepareForDownload{
    _fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![_fileManager fileExistsAtPath:self.downloadPath isDirectory:&isDir]) {
        [_fileManager createDirectoryAtPath:self.downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    _downloadInfo = [NSMutableDictionary dictionaryWithContentsOfFile:[_downloadPath stringByAppendingPathComponent:@"DownloadInfo.plist"]];
    if (!_downloadInfo) {
        _downloadInfo = [NSMutableDictionary dictionary];
        [_downloadInfo setValue:[NSMutableDictionary dictionary] forKey:@"completeList"];
        [_downloadInfo setValue:[NSMutableDictionary dictionary] forKey:@"downloadList"];
        [_downloadInfo writeToFile:[_downloadPath stringByAppendingPathComponent:@"DownloadInfo.plist"] atomically:YES];
    }
    _downloadingDic = [NSMutableDictionary dictionary];
}

- (void)addDownloadMissionWithTitle:(NSString *)title andDictionary:(NSDictionary *)dict{
    NSMutableDictionary *downloadList = _downloadInfo[@"downloadList"];
    NSMutableDictionary *changeDict = [downloadList objectForKey:title];
    if (!changeDict) {
        [downloadList setValue:dict forKey:title];
    }else{
        for (NSString *key in [dict allKeys]) {
            if ([self fileExistInListWithTitle:title andSubtitle:key]) {
                continue;
            }
            [changeDict setValue:dict[key] forKey:key];
        }
    }
    NSString *filePath = [_downloadPath stringByAppendingPathComponent:title];
    BOOL isDir = YES;
    if (![_fileManager fileExistsAtPath:filePath isDirectory:&isDir]) {
        [_fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [_downloadInfo writeToFile:[_downloadPath stringByAppendingPathComponent:@"DownloadInfo.plist"] atomically:YES];
}

- (BOOL)deleteMissionWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle{
    NSMutableDictionary *downloadList = _downloadInfo[@"downloadList"];
    NSMutableDictionary *completeList = _downloadInfo[@"completeList"];
    NSMutableDictionary *changeDict = downloadList[title];
    
    [changeDict removeObjectForKey:subTitle];
    if (!changeDict.allKeys.count) {
        [downloadList removeObjectForKey:title];
    }
    
    changeDict = completeList[title];
    
    [changeDict removeObjectForKey:subTitle];
    if (!changeDict.allKeys.count) {
        [completeList removeObjectForKey:title];
    }
    
    [_downloadInfo writeToFile:[_downloadPath stringByAppendingPathComponent:@"DownloadInfo.plist"] atomically:YES];
    NSString *filePath = [_downloadPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.mp4",title,subTitle]];
    [_fileManager removeItemAtPath:filePath error:nil];
    return YES;
}

- (void)completeDownloadMissionWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle urlstring:(NSString *)urlstring{
    NSMutableDictionary *completeList = _downloadInfo[@"completeList"];
    NSMutableDictionary *downloadList = _downloadInfo[@"downloadList"];
    if (!completeList[title]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [completeList setObject:dic forKey:title];
    }
    [completeList[title] setObject:downloadList[title][subtitle] forKey:subtitle];
    [downloadList[title] removeObjectForKey:subtitle];
    if (![downloadList[title] allKeys].count) {
        [downloadList removeObjectForKey:title];
    }
    [_downloadInfo writeToFile:[_downloadPath stringByAppendingPathComponent:@"DownloadInfo.plist"] atomically:YES];
    [self cancelADownloadMissionWithUrlString:urlstring];
}

- (void)cancelADownloadMissionWithUrlString:(NSString *)urlString{
    [_downloadingDic removeObjectForKey:urlString];
    _downloadCount--;
}

- (BOOL)fileExistInListWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle{
    NSDictionary *downloadList = _downloadInfo[@"downloadList"];
    if (downloadList[title][subtitle]) {
        return YES;
    }
    NSDictionary *completeList = _downloadInfo[@"completeList"];
    if (completeList[title][subtitle]) {
        return YES;
    }
    return NO;
}

- (void)startADownloadMissionWithUrlstring:(NSString *)urlstring andDownloader:(id)downloader{
    [_downloadingDic setObject:downloader forKeyedSubscript:urlstring];
    _downloadCount++;
}

- (Downloader *)getDownloaderWithUrlstring:(NSString *)urlString{
    return _downloadingDic[urlString];
}

- (NSDictionary *)downloadList{
    return [_downloadInfo[@"downloadList"] copy];
}

- (NSDictionary *)completeList{
    return [_downloadInfo[@"completeList"] copy];
}

- (void)startDownloadWithTitle:(NSString *)title andCourseName:(NSString *)courseName{
    NSLog(@"%@",_downloadInfo[@"downloadList"][title][courseName]);
}

- (BOOL)allowToDownload{
    NSLog(@"当前下载任务有%li个",_downloadCount);
    if (_downloadCount < 3) {
        return YES;
    }
    return NO;
}

@end

@interface Downloader () <NSURLConnectionDataDelegate>

@end

@implementation Downloader
{
    NSURLConnection *_connection;
    NSString *_filePath;
    NSString *_urlString;
    NSFileHandle *_fh;
    NSUInteger _fileSize;
    NSUInteger _localSize;
    NSMutableData *_receiveData;
}

- (void)downloadWithURLString:(NSString *)urlString andPath:(NSString *)filePath successBlock:(success)successBlock failBlock:(fail)failureBlock response:(getResponse)responseBlock saveData:(saveData)saveBlock{
    if (!urlString.length) {
        return;
    }
    self.successBlock = successBlock;
    self.failBlock = failureBlock;
    self.responseBlock = responseBlock;
    self.saveBlock = saveBlock;
    _filePath = filePath;
    _urlString = urlString;
    [self startDownload];
    [[DownloadManager shareManager] startADownloadMissionWithUrlstring:urlString andDownloader:self];
}

- (void)startDownload{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:_filePath]) {
        [manager createFileAtPath:_filePath contents:nil attributes:nil];
    }
    _fh = [NSFileHandle fileHandleForUpdatingAtPath:_filePath];
    _localSize = [_fh readDataToEndOfFile].length;
    _receiveData = [[_fh readDataToEndOfFile] mutableCopy];
    NSURL *url = [NSURL URLWithString:_urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *range = [NSString stringWithFormat:@"bytes=%lu-",_localSize];
    [request setValue:range forHTTPHeaderField:@"range"];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)stopDownload{
    [_fh writeData:_receiveData];
    [_fh synchronizeFile];
    [_fh closeFile];
    [[DownloadManager shareManager] cancelADownloadMissionWithUrlString:_urlString];
    [_connection cancel];
    _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.failBlock(_filePath,_urlString);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.responseBlock(response);
    _fileSize = _localSize + response.expectedContentLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_receiveData appendData:data];
    _localSize += data.length;
    self.saveBlock((float)_localSize/(float)_fileSize);
    [self.delegate downloadChangeDatalength:(float)_localSize/(float)_fileSize];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.successBlock(_receiveData);
    [self.delegate downloadSuccess:_receiveData];
    [_fh writeData:_receiveData];
    [_fh synchronizeFile];
    [_fh closeFile];
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

@end
