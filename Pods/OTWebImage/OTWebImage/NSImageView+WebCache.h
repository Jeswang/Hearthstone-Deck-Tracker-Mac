//
//  NSImageView+WebCache.h
//  163Music
//
//  Created by openfibers on 27/5/14.
//  Copyright (c) 2014 openthread. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol NSImageViewWebCacheDelegate <NSObject>

- (void)imageView:(NSImageView *)imageView downloadImageSuccessed:(NSImage *)image data:(NSData *)data;
- (void)imageViewDownloadImageFailed:(NSImageView *)imageView;

@end

@interface NSImageView (WebCache)

@property (nonatomic, weak) id<NSImageViewWebCacheDelegate> webCacheDelegate;
@property (nonatomic, retain) NSURL *imageURL;
- (void)cancelWebImageLoad;

@end
