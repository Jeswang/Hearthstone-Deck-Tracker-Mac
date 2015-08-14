//
//  OTImageDownloadRequest.m
//  163Music
//
//  Created by openthread on 6/7/14.
//  Copyright (c) 2014 openthread. All rights reserved.
//

#import "OTWebImageDownloadRequest.h"
#import "OTHTTPRequest.h"
#import "OTFileCacheManager.h"

@interface OTWebImageDownloadRequest () <OTHTTPRequestDelegate>
@end

@implementation OTWebImageDownloadRequest
{
    OTHTTPRequest *_request;
    NSString *_URLString;
    NSURL *_URL;
}

+ (OTWebImageDownloadRequest *)requestWithURL:(NSURL *)URL
{
    OTWebImageDownloadRequest *request = [[self alloc] initWithURL:URL];
    return request;
}

+ (OTFileCacheManager *)fileCacheManagerInstance
{
    static OTFileCacheManager *managerInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *defaultCachePath = [OTFileCacheManager defaultCachePath];
        defaultCachePath = [defaultCachePath stringByAppendingPathComponent:@"OTImageWebCache"];
        managerInstance = [[OTFileCacheManager alloc] initWithCachePath:defaultCachePath];
    });
    return managerInstance;
}

- (id)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self)
    {
        _URL = URL;
        _URLString = [URL absoluteString];
    }
    return self;
}

- (NSString *)URLString
{
    return _URLString;
}

- (NSURL *)URL
{
    return _URL;
}

- (void)start
{
    OTFileCacheManager *cacheManager = [[self class] fileCacheManagerInstance];
    BOOL useCacheSuccessed = NO;
    if ([cacheManager cacheDataExistForKey:_URLString])
    {
        if ([self.delegate respondsToSelector:@selector(otWebImageDownloadRequest:downloadSuccessedWithData:isFromCache:)])
        {
            NSData *data = [cacheManager dataForKey:_URLString];
            if (data)
            {
                useCacheSuccessed = YES;
                [self.delegate otWebImageDownloadRequest:self
                               downloadSuccessedWithData:data
                                             isFromCache:YES];
            }
        }
    }

    if (!useCacheSuccessed)
    {
        if (!_request)
        {
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:_URL];
            _request = [[OTHTTPRequest alloc] initWithNSURLRequest:urlRequest];
            _request.delegate = (id<OTHTTPRequestDelegate>)self;
        }
        [_request start];
    }
}

- (void)cancel
{
    [_request cancel];
}

- (void)otHTTPRequest:(OTHTTPRequest *)request dataUpdated:(NSData *)data totalData:(NSData *)totalData
{
    if ([self.delegate respondsToSelector:@selector(otWebImageDownloadRequest:imageDataUpdated:)])
    {
        [self.delegate otWebImageDownloadRequest:self imageDataUpdated:totalData];
    }
}

- (void)otHTTPRequestFinished:(OTHTTPRequest *)request
{
    NSData *responseData = nil;
    if ([self.delegate respondsToSelector:@selector(otWebImageDownloadRequest:downloadSuccessedWithData:isFromCache:)])
    {
        responseData = request.responseData;
        [self.delegate otWebImageDownloadRequest:self
                       downloadSuccessedWithData:responseData
                                     isFromCache:NO];
    }
    if (responseData)
    {
        OTFileCacheManager *cacheManager = [[self class] fileCacheManagerInstance];
        [cacheManager storeData:responseData forKey:_URLString];
    }
}

- (void)otHTTPRequestFailed:(OTHTTPRequest *)request error:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(otWebImageDownloadRequest:failedWithError:)])
    {
        [self.delegate otWebImageDownloadRequest:self failedWithError:error];
    }
}

@end
