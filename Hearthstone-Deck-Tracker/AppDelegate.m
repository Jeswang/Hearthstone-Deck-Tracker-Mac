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
#import "Hearthstone.h"

@interface AppDelegate ()

@property (nonatomic, weak) IBOutlet NSWindow *window;
@property (nonatomic, weak) IBOutlet NSWindowController *cardListController;
@property (nonatomic) IBOutlet NSWindowController *settingsWindow;
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

    [[Hearthstone defaultInstance] setStatusDidUpdate:^(BOOL isRunning) {
        NSLog(@"Hearthstone is running? %d", isRunning);
    }];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    return YES;
}

- (void)updateWithCards:(NSArray *)cards {
    for (NSObject<CardListDelegate>* list in self.updateList) {
        [list updateWithCards:cards];
    }
}

- (IBAction)openSettings:(id)sender {
    if (!self.settingsWindow) {
        NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Settings" bundle:nil];
        self.settingsWindow = [storyboard instantiateInitialController];
    }
    if (self.settingsWindow) {
        [self.settingsWindow showWindow:nil];
    }
}

@end
