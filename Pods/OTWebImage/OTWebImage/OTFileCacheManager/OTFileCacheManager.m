//
//  OTFileCacheManager.m
//  163Music
//
//  Created by openthread on 6/7/14.
//  Copyright (c) 2014 openthread. All rights reserved.
//

#import "OTFileCacheManager.h"

@implementation OTFileCacheManager
{
    NSString *_cachePath;
}

+ (NSString *)defaultCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (paths.count == 0)
    {
        return nil;
    }
    NSString *cachePath = paths[0];
    cachePath = [cachePath stringByAppendingPathComponent:@"OTFileCache"];
    return cachePath;
}

- (id)init
{
    self = [self initWithCachePath:[[self class] defaultCachePath]];
    return self;
}

- (id)initWithCachePath:(NSString *)cachePath
{
    self = [self initWithCachePath:cachePath
                     maxCacheBytes:200 * 1000 * 1000
               cacheExpireDuration:7 * 24 * 60 * 60];
    return self;
}

- (id)initWithCachePath:(NSString *)cachePath
          maxCacheBytes:(unsigned long long)maxCacheBytes
    cacheExpireDuration:(NSTimeInterval)cacheExpireDuration
{
    self = [super init];
    if (self)
    {
        _cachePath = cachePath;
        [[NSFileManager defaultManager] createDirectoryAtPath:_cachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        self.maxCacheBytes = maxCacheBytes;
        self.cacheExpireDuration = cacheExpireDuration;
    }
    return self;
}

- (void)setMaxCacheBytes:(long long)maxCacheBytes
{
    _maxCacheBytes = maxCacheBytes;
    [self clearCacheToMaxBytes];
}

- (void)setCacheExpireDuration:(CGFloat)cacheExpireDuration
{
    _cacheExpireDuration = cacheExpireDuration;
    [self clearExpiredCache];
}

- (void)clearAllCache
{
    NSString *cachePath = _cachePath;
    NSArray *dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:nil];
    for (NSString *filename in dirFiles)
    {
        NSString *fullPath = [cachePath stringByAppendingPathComponent:filename];
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    }
}

- (void)clearExpiredCache
{
    NSString *cachePath = _cachePath;
    NSDate *now = [NSDate date];
    NSArray *dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:nil];
    for (NSString *filename in dirFiles)
    {
        if ([filename isEqualToString:@".DS_Store"])
        {
            continue;
        }
        NSString *fullPath = [cachePath stringByAppendingPathComponent:filename];
        NSFileManager* fm = [NSFileManager defaultManager];
        NSDictionary* attrs = [fm attributesOfItemAtPath:fullPath error:nil];
        NSDate *date = [attrs fileCreationDate];
        NSTimeInterval passedInterval = [now timeIntervalSinceDate:date];
        BOOL expired = passedInterval > self.cacheExpireDuration;
        if (expired)
        {
            [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
        }
    }
}

- (void)clearCacheToMaxBytes
{
    unsigned long long currentCacheSize = [self currentCacheSize];
    while (currentCacheSize > self.maxCacheBytes)
    {
        currentCacheSize = [self removeLastFileInCacheFolderWithCurrentCacheSize:currentCacheSize
                                                                    maxCacheSize:self.maxCacheBytes];
    }
}

- (unsigned long long)removeLastFileInCacheFolderWithCurrentCacheSize:(unsigned long long)currentCacheSize
                                                         maxCacheSize:(unsigned long long)maxCacheSize
{
    NSString *const filePathKey = @"filePath";
    NSString *cachePath = _cachePath;
    NSArray *dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:nil];
    int fileSizeCalcCount = 5;
    NSMutableArray *oldestFileAttributesArray = [NSMutableArray array];
    BOOL (^isAttribOlderThan)(NSDictionary*, NSDictionary *) = ^(NSDictionary *first, NSDictionary *second)
    {
        NSDate *firstDate = first[NSFileCreationDate];
        NSDate *secondDate = second[NSFileCreationDate];
        NSComparisonResult comparisonResult = [firstDate compare:secondDate];
        if (comparisonResult == NSOrderedAscending)
        {
            return YES;
        }
        return NO;
    };
    for (NSString *filename in dirFiles)
    {
        NSString *fullPath = [cachePath stringByAppendingPathComponent:filename];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
        if (attributes)
        {
            if (oldestFileAttributesArray.count < fileSizeCalcCount)
            {
                NSMutableDictionary *mutableAttributes = [attributes mutableCopy];
                [mutableAttributes setObject:fullPath forKey:filePathKey];
                [oldestFileAttributesArray addObject:mutableAttributes];
            }
            else
            {
                for (int i = 0; i<oldestFileAttributesArray.count; i++)
                {
                    NSDictionary *dic = oldestFileAttributesArray[i];
                    if (isAttribOlderThan(attributes, dic))
                    {
                        NSMutableDictionary *mutableAttributes = [attributes mutableCopy];
                        [mutableAttributes setObject:fullPath forKey:filePathKey];
                        [oldestFileAttributesArray replaceObjectAtIndex:i withObject:mutableAttributes];
                    }
                }
            }
        }
    }
    
    while (currentCacheSize > maxCacheSize && oldestFileAttributesArray.count > 0)
    {
        NSMutableDictionary *attributeDic = oldestFileAttributesArray[0];
        NSNumber *fileSize = attributeDic[NSFileSize];
        NSString *filePath = attributeDic[filePathKey];
        [oldestFileAttributesArray removeObject:attributeDic];
        if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:nil])
        {
            currentCacheSize -= fileSize.unsignedLongLongValue;
        }
    }
    
    return currentCacheSize;
}

- (unsigned long long)currentCacheSize
{
    NSString *cachePath = _cachePath;
    unsigned long long size = [self folderSizeOfPath:cachePath];
    return size;
}

- (unsigned long long)folderSizeOfPath:(NSString *)folderPath
{
    NSArray *contents;
    NSEnumerator *enumerator;
    NSString *path;
    unsigned long long fileSize = 0;
    contents = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    enumerator = [contents objectEnumerator];
    while (path = [enumerator nextObject])
    {
        NSString *filePath = [folderPath stringByAppendingPathComponent:path];
        NSError *error = nil;
        NSDictionary *attrib = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
        if (!error)
        {
            fileSize += [attrib fileSize];
        }
    }
    return fileSize;
}

- (BOOL)cacheDataExistForKey:(NSString *)key
{
    NSString *fileName = [[self class] md5:key];
    NSString *filePath = [_cachePath stringByAppendingPathComponent:fileName];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return fileExist;
}

- (NSData *)dataForKey:(NSString *)key
{
    NSString *fileName = [[self class] md5:key];
    NSString *filePath = [_cachePath stringByAppendingPathComponent:fileName];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    return data;
}

- (BOOL)storeData:(NSData *)data forKey:(NSString *)key
{
    NSString *fileName = [[self class] md5:key];
    NSString *filePath = [_cachePath stringByAppendingPathComponent:fileName];
    BOOL result = [data writeToFile:filePath atomically:YES];
    [self clearCacheToMaxBytes];
    return result;
}

+ (NSString *)md5:(NSString *)aStr
{
    if (!aStr)
    {
        return nil;
    }
	const char *cStr = [aStr UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
	return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
