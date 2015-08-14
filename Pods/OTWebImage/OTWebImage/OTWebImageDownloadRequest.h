//
//  OTImageDownloadRequest.h
//  163Music
//
//  Created by openthread on 6/7/14.
//  Copyright (c) 2014 openthread. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTWebImageDownloadRequest;
@protocol OTWebImageDownloadRequestDelegate <NSObject>

- (void)otWebImageDownloadRequest:(OTWebImageDownloadRequest *)request
        downloadSuccessedWithData:(NSData *)imageData
                      isFromCache:(BOOL)isFromCache;
- (void)otWebImageDownloadRequest:(OTWebImageDownloadRequest *)request
                  failedWithError:(NSError *)error;

@optional
- (void)otWebImageDownloadRequest:(OTWebImageDownloadRequest *)request
                 imageDataUpdated:(NSData *)imageData;

@end

@interface OTWebImageDownloadRequest : NSObject

+ (OTWebImageDownloadRequest *)requestWithURL:(NSURL *)URL;
- (id)initWithURL:(NSURL *)URL;

@property (nonatomic, readonly) NSString *URLString;
@property (nonatomic, readonly) NSURL *URL;

@property (nonatomic, weak) id<OTWebImageDownloadRequestDelegate> delegate;
- (void)start;
- (void)cancel;

@end
