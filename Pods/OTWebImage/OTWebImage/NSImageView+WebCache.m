//
//  NSImageView+WebCache.m
//  163Music
//
//  Created by openfibers on 27/5/14.
//  Copyright (c) 2014 openthread. All rights reserved.
//

#import "NSImageView+WebCache.h"
#import <objc/runtime.h>
#import "OTWebImageDownloadRequest.h"

NSString *const NSImageViewWebCacheImageRequestPropertyKey = @"NSImageViewWebCacheImageRequestPropertyKey";
NSString *const NSImageViewWebCacheDelegatePropertyKey = @"NSImageViewWebCacheDelegatePropertyKey";

//@interface NSImageView () <OTHTTPRequestDelegate>
//@property (nonatomic, retain) OTHTTPRequest *imageRequest;
//@end

@implementation NSImageView (WebCache)

- (id<NSImageViewWebCacheDelegate>)webCacheDelegate
{
    id<NSImageViewWebCacheDelegate> delegate = objc_getAssociatedObject(self, (__bridge const void *)(NSImageViewWebCacheDelegatePropertyKey));
    return delegate;
}

- (void)setWebCacheDelegate:(id<NSImageViewWebCacheDelegate>)webCacheDelegate
{
    objc_setAssociatedObject(self, (__bridge const void *)(NSImageViewWebCacheDelegatePropertyKey), webCacheDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (OTWebImageDownloadRequest *)imageRequest
{
    OTWebImageDownloadRequest *request = objc_getAssociatedObject(self, (__bridge const void *)(NSImageViewWebCacheImageRequestPropertyKey));
    return request;
}

- (void)setImageRequest:(OTWebImageDownloadRequest *)request
{
    objc_setAssociatedObject(self, (__bridge const void *)(NSImageViewWebCacheImageRequestPropertyKey), request, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURL *)imageURL
{
    OTWebImageDownloadRequest *request = [self imageRequest];
    NSURL *url = request.URL;
    return url;
}

- (void)setImageURL:(NSURL *)imageURL
{
    [self cancelWebImageLoad];
    OTWebImageDownloadRequest *request = self.imageRequest;
    if (!request)
    {
        request = [OTWebImageDownloadRequest requestWithURL:imageURL];
        request.delegate = (id<OTWebImageDownloadRequestDelegate>)self;
        self.imageRequest = request;
    }
    [request start];
}

- (void)cancelWebImageLoad
{
    OTWebImageDownloadRequest *request = [self imageRequest];
    [request cancel];
    [self setImageRequest:nil];
}

- (void)otWebImageDownloadRequest:(OTWebImageDownloadRequest *)request
        downloadSuccessedWithData:(NSData *)imageData
                      isFromCache:(BOOL)isFromCache
{
    if (imageData != nil)
    {
        NSImage *newImage = [[NSImage alloc] initWithData:imageData];
        [self setImage:newImage];
        if ([self.webCacheDelegate respondsToSelector:@selector(imageView:downloadImageSuccessed:data:)])
        {
            [self.webCacheDelegate imageView:self downloadImageSuccessed:newImage data:imageData];
        }
    }
    else
    {
        if ([self.webCacheDelegate respondsToSelector:@selector(imageViewDownloadImageFailed:)])
        {
            [self.webCacheDelegate imageViewDownloadImageFailed:self];
        }
    }
    [self setImageRequest:nil];

}

- (void)otWebImageDownloadRequest:(OTWebImageDownloadRequest *)request
                  failedWithError:(NSError *)error
{
    if ([self.webCacheDelegate respondsToSelector:@selector(imageViewDownloadImageFailed:)])
    {
        [self.webCacheDelegate imageViewDownloadImageFailed:self];
    }
    [self setImageRequest:nil];
}

@end
