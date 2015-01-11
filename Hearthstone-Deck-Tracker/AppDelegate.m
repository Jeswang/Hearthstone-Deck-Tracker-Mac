//
//  AppDelegate.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/9.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "AppDelegate.h"
#import "RealmGenerator.h"
#import "CardModel.h"

@interface AppDelegate ()

@property (nonatomic, weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //[RealmGenerator generateCardRealm];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    return YES;
}

@end
