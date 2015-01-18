//
//  LogObserver.h
//  hearth
//
//  Created by Simon Andersson on 05/08/14.
//  Copyright (c) 2014 hiddencode.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogObserver : NSObject

@property (nonatomic, copy) void(^didReadLine)(NSString *line);

- (void)start;
- (void)stop;

@end
