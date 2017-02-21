//
//  PPSNetSpeedTest.m
//  网络速度测试
//
//  Created by 羊谦 on 2017/2/21.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import "PPSNetSpeedTest.h"
#import <AFNetworking.h>

static NSString *const FILE_PATH = @"http://sw.bos.baidu.com/sw-search-sp/software/d28b12c330f7b/android-studio-bundle_2.2.0.0.exe";

@interface PPSNetSpeedTest()

@property (nonatomic, strong)AFURLSessionManager *urlManager;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger completeFile;
@property (nonatomic, assign)NSInteger lastSecondCompleteFile;
@property (nonatomic, copy)NetSpeedBlock callBackBlock;
@property (nonatomic, copy)NetSpeedBlock completeBlock;
@property (nonatomic, strong)NSURLSessionDownloadTask *downloadTask;

@end


@implementation PPSNetSpeedTest
{
    int _second;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _urlManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _completeFile = 0;
        _lastSecondCompleteFile = 0;
    }
    return self;
}

-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

- (void)startDownLoadTestWithCallBlock:(NetSpeedBlock)callBackBlock completeBlock:(NetSpeedBlock)completeBlock{
    self.callBackBlock = callBackBlock;
    self.completeBlock = completeBlock;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:FILE_PATH]];
    self.downloadTask = [_urlManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        _completeFile = downloadProgress.completedUnitCount;
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"完成下载,然后删除文件");
        NSString *filesTR = filePath.path;
        if (_second<9) {
            [self finishDownLoad];//网速太快，10秒内下载完毕
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:filesTR]) {
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtURL:filePath error:&error];
        }
    }];
    [self.downloadTask resume];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    [_timer fire];
    _second = 0;
}

- (void)countTime{
    ++ _second;
    if (_second == 9) {
        [self finishCurrentTest];
        CGFloat averageSpeed = self.completeFile/(pow(1024, 2)*10.0);
        self.completeBlock([NSString stringWithFormat:@"%.2fM",averageSpeed]);
        self.completeBlock = nil;
        [self.downloadTask cancel];
        return;
    }
    NSInteger everySecondFile = self.completeFile - self.lastSecondCompleteFile;
    CGFloat sppeed = everySecondFile/pow(1024, 2)*1.0;
    self.callBackBlock([NSString stringWithFormat:@"%.2fM",sppeed]);
    self.lastSecondCompleteFile = self.completeFile;
}

- (void)finishDownLoad{
    [self finishCurrentTest];
    ++ _second;
    CGFloat averageSpeed = self.completeFile/(pow(1024, 2)*(_second+1)*1.0);
    self.completeBlock([NSString stringWithFormat:@"%.2fM",averageSpeed]);
    self.completeBlock = nil;
    self.callBackBlock = nil;
    [self.downloadTask cancel];
}

- (void)finishCurrentTest{
    [_timer invalidate];
    _timer = nil;
}

@end
