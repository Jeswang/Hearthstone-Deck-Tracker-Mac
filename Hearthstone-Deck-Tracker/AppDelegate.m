//
//  AppDelegate.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/9.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "AppDelegate.h"
#import "CardModel.h"
#import "CardListViewController.h"
#import "RealmGenerator.h"
#import "NetEaseCardBuilderImporter.h"

@interface AppDelegate ()

@property (nonatomic, weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (instancetype)init {
    id instance = [super init];
    if (instance) {
        _updateList = [NSMutableArray new];
    }
    return instance;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //[RealmGenerator generateCardRealm];    
    [NetEaseCardBuilderImporter importDockerWithId:@"42621"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    return YES;
}

- (void)updateWithCards:(NSArray *)cards {
    for (NSObject<CardListDelegate>* list in self.updateList) {
        [list updateWithCards:cards];
    }
}

@end
