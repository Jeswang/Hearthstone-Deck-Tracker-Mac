//
//  Hearthstone.h
//  hearth
//
//  Created by Simon Andersson on 05/08/14.
//  Copyright (c) 2014 hiddencode.me. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    PlayerMe,
    PlayerOpponent
} Player;

@interface Hearthstone : NSObject

@property (nonatomic, copy) void(^statusDidUpdate)(BOOL isRunning);

+ (instancetype)defaultInstance;

+ (NSString *)logPath;

- (BOOL)isHearthstoneRunning;

@property (nonatomic, strong) NSMutableArray *updateList;

@end
