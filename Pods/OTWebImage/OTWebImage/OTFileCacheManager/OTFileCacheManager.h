//
//  OTFileCacheManager.h
//  163Music
//
//  Created by openthread on 6/7/14.
//  Copyright (c) 2014 openthread. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface OTFileCacheManager : NSObject

+ (NSString *)defaultCachePath;

//init with default cache path : `NSCachesDirectory`
//Default max cache bytes is 200 MB.
//Default cache duration is 1 week.
- (id)init;

//Init with a specific path.
//Default max cache bytes is 200 MB.
//Default cache duration is 1 week.
- (id)initWithCachePath:(NSString *)cachePath;

//Init with a specific path, max cache bytes and expire duration
- (id)initWithCachePath:(NSString *)cachePath
          maxCacheBytes:(unsigned long long)maxCacheBytes
    cacheExpireDuration:(NSTimeInterval)cacheExpireDuration;

//Set cache limit
@property (nonatomic, assign) long long maxCacheBytes;
@property (nonatomic, assign) CGFloat cacheExpireDuration;

//Clear cache methods
- (void)clearAllCache;
- (void)clearCacheToMaxBytes;
- (void)clearExpiredCache;

//Cache for key
- (BOOL)cacheDataExistForKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;
- (BOOL)storeData:(NSData *)data forKey:(NSString *)key;

@end
