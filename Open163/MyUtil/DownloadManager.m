//
//  DownloadManager.m
//  Open163
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 cxk. All rights reserved.
//

#import "DownloadManager.h"


@interface DownloadManager ()

@property (nonatomic,strong,readonly) NSString * downloadPath;

@property (nonatomic,strong) NSMutableDictionary * downloadInfo;

@end

@implementation DownloadManager
{
    NSFileManager *_fileManager;
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
    
}

- (void)addDownloadMissionWithTitle:(NSString *)title andDictionary:(NSDictionary *)dict{
    NSMutableDictionary *downloadList = _downloadInfo[@"downloadList"];
    NSMutableDictionary *changeDict = [downloadList objectForKey:title];
    if (!changeDict) {
        [downloadList setValue:dict forKey:title];
    }else{
        for (NSString *key in [dict allKeys]) {
            if ([[changeDict allKeys] containsObject:key]) {
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
    NSMutableDictionary *changeDict = downloadList[title];
    if (!changeDict) {
        return NO;
    }
    [changeDict removeObjectForKey:subTitle];
    if (!changeDict.allKeys.count) {
        [downloadList removeObjectForKey:title];
    }
    [_downloadInfo writeToFile:[_downloadPath stringByAppendingPathComponent:@"DownloadInfo.plist"] atomically:YES];
    return YES;
}

- (NSDictionary *)downloadList{
    return [_downloadInfo[@"downloadList"] copy];
}

- (NSDictionary *)completeList{
    return [_downloadInfo[@"completeList"] copy];
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
}

- (void)downloadWithURLString:(NSString *)urlString andPath:(NSString *)filePath successBlock:(success)successBlock failBlock:(fail)failureBlock response:(getResponse)responseBlock{
    if (!urlString.length) {
        return;
    }
    self.successBlock = successBlock;
    self.failBlock = failureBlock;
    self.responseBlock = responseBlock;
    _filePath = filePath;
    _urlString = urlString;
    [self startDownload];
}

- (void)startDownload{
    _fh = [NSFileHandle fileHandleForUpdatingAtPath:_filePath];
    _localSize = [_fh readDataToEndOfFile].length;
    NSURL *url = [NSURL URLWithString:_urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *range = [NSString stringWithFormat:@"bytes=%lu-",_localSize];
    [request setValue:range forHTTPHeaderField:@"range"];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)stopDownload{
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
    [_fh seekToFileOffset:_localSize];
    [_fh writeData:data];
    _localSize += data.length;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.successBlock(_filePath,_urlString);
    [_fh closeFile];
}

@end
