//
//  Hearthstone.m
//  hearth
//
//  Created by Simon Andersson on 05/08/14.
//  Copyright (c) 2014 hiddencode.me. All rights reserved.
//

#import "Hearthstone.h"

#import "LogAnalyzer.h"
#import "LogObserver.h"

#import "CardListViewController.h"

@interface Hearthstone ()
@property LogObserver *logObserver;
@property LogAnalyzer *logAnalyzer;
@end

@implementation Hearthstone

+ (instancetype)defaultInstance {
    static Hearthstone *INSTANCE = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        INSTANCE = [[[self class] alloc] init];
    });
    return INSTANCE;
}

+ (NSString *)configPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/Blizzard/Hearthstone/log.config"];
}

+ (NSString *)logPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Logs/Unity/Player.log"];
}

+ (NSString*)newConfigPath {
    static NSString *absPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *appBundle = [NSBundle mainBundle];
        absPath = [appBundle pathForResource:@"log" ofType:@"config" inDirectory:@"Files"];
        NSLog(@"%@", absPath);
    });
    return absPath;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.updateList = [NSMutableArray new];
        [self setup];
        [self listener];
    }
    return self;
}

- (void)setup {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:[[self class] configPath]]) {
        NSStringEncoding encoding = NSASCIIStringEncoding;
        NSString *filePath = [Hearthstone newConfigPath];
        NSString *file = [NSString stringWithContentsOfFile:filePath usedEncoding:&encoding error:nil];

        NSString *dir = [[[self class] configPath] stringByDeletingLastPathComponent];
        
        [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        
        [file writeToFile:[[self class] configPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)listener {
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(workspaceDidLaunchApplication:) name:NSWorkspaceDidLaunchApplicationNotification object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(workspaceDidTerminateApplication:) name:NSWorkspaceDidTerminateApplicationNotification object:nil];
    
    if ([self isHearthstoneRunning]) {
        [self startTracking];
    }
}

- (BOOL)isHearthstoneRunning {
    for (NSRunningApplication *app in [[NSWorkspace sharedWorkspace] runningApplications]) {
        if ([[app localizedName] isEqualToString:@"Hearthstone"]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Observer selectors for Hearthstone

- (void)workspaceDidLaunchApplication:(NSNotification *)notification {
    
    NSRunningApplication *application = [[notification userInfo] objectForKey:@"NSWorkspaceApplicationKey"] ?: nil;
    if (application) {
        NSString *applicationName = [application localizedName];
        if ([applicationName isEqualToString:@"Hearthstone"]) {
            [self startTracking];
            if (_statusDidUpdate) {
                _statusDidUpdate(YES);
            }
        }
    }
}

- (void)workspaceDidTerminateApplication:(NSNotification *)notification {
    NSRunningApplication *application = [[notification userInfo] objectForKey:@"NSWorkspaceApplicationKey"] ?: nil;
    if (application) {
        NSString *applicationName = [application localizedName];
        if ([applicationName isEqualToString:@"Hearthstone"]) {
            [self stopTracking];

            if (_statusDidUpdate) {
                _statusDidUpdate(NO);
            }
        }
    }
}

- (void)startTracking {
    __weak typeof(self) ws = self;
    _logObserver = [LogObserver new];
    _logAnalyzer = [LogAnalyzer new];
    
    [_logAnalyzer setPlayerHero:^(Player player, NSString *heroId) {
        if (player == PlayerMe) {
            NSLog(@"----- Game Started -----");
            for (NSObject<CardListDelegate>* list in ws.updateList) {
                [list resetCards];
            }
        }
        NSLog(@"Player %u picked %@", player, heroId);
    }];
    
    [_logAnalyzer setPlayerDidDiscardCard:^(Player player, NSString *cardId) {
        NSLog(@"Player %u discard card %@", player, cardId);
    }];
    
    [_logAnalyzer setPlayerDidPlayCard:^(Player player, NSString *cardId) {
        NSLog(@"Player %u played card %@", player, cardId);
    }];
    
    [_logAnalyzer setPlayerDidReturnCard:^(Player player, NSString *cardId) {
        NSLog(@"Player %u return %@", player, cardId);
    }];
    
    [_logAnalyzer setPlayerGotCoin:^(Player player) {
        NSLog(@"Player %u got the coin", player);
    }];
    
    [_logAnalyzer setPlayerDidDie:^(Player player) {
        NSLog(@"Player %u died", player);
        for (NSObject<CardListDelegate>* list in ws.updateList) {
            [list resetCards];
        }
        NSLog(@"----- Game End -----");
    }];
    
    [_logAnalyzer setPlayerDidDrawCard:^(Player player, NSString * card) {
        NSLog(@"Player %u drawed %@", player, card);
        for (NSObject<CardListDelegate>* list in ws.updateList) {
            [list removeCard:card];
        }
    }];
    
    _logObserver.didReadLine = ^(NSString *line) {
        [ws.logAnalyzer analyzeLine:line];
    };
    
    [_logObserver start];
}

- (void)stopTracking {
    [_logObserver stop];
    _logObserver = nil;
    _logAnalyzer = nil;
}

- (void)setStatusDidUpdate:(void (^)(BOOL isRunning))statusDidUpdate {
    _statusDidUpdate = statusDidUpdate;
    _statusDidUpdate([self isHearthstoneRunning]);
}

@end
