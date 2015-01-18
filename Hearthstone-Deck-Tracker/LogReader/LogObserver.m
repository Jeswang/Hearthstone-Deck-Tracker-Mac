//
//  LogObserver.m
//  hearth
//
//  Created by Simon Andersson on 05/08/14.
//  Copyright (c) 2014 hiddencode.me. All rights reserved.
//

#import "LogObserver.h"
#import "Hearthstone.h"
#import <sys/stat.h>

static const float kLogObserverRefreshRate = 0.5;

@interface LogObserver ()
@property NSInteger lastReadPosition;
@property BOOL shouldRun;
@end


@implementation LogObserver

- (instancetype)init {
    self = [super init];
    if (self) {
        _lastReadPosition = 0;
    }
    return self;
}


- (void)start {
    NSString *path = Hearthstone.logPath;
    _shouldRun = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        _lastReadPosition = [self fileSize:path];
    }
    [self changesInFile];
}

- (NSInteger)fileSize:(NSString *)path {
    struct stat stats;
    if (stat([path fileSystemRepresentation], &stats)) {
        // Errornous behaviour
    }
    
    long long size = stats.st_size;
    
    return size;
}

- (void)changesInFile {
    NSString *path = Hearthstone.logPath;
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    [fileHandle seekToFileOffset:_lastReadPosition];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSData *linesData = [fileHandle readDataToEndOfFile];
        NSString *linesString = [[NSString alloc] initWithData:linesData encoding:NSUTF8StringEncoding];
        NSInteger size = _lastReadPosition;
        _lastReadPosition = [self fileSize:path];
        
        if (_lastReadPosition > size) {
            
            NSArray *lines = [linesString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (lines.count > 0) {
                    for (NSString *line in lines) {
                        if (_didReadLine) {
                            _didReadLine(line);
                        }
                    }
                }
            });
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kLogObserverRefreshRate * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_shouldRun) {
                [self changesInFile];
            }
        });
    });
}

- (void)stop {
    _shouldRun = NO;
}

@end
