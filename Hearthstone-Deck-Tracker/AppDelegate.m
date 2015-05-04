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
#import "CardListWindowController.h"
#import "DeckManangerWindowController.h"
#import "RealmGenerator.h"
#import "NetEaseCardBuilderImporter.h"
#import "Hearthstone.h"
#import "SettingGeneralViewController.h"
#import "MASPreferencesWindowController.h"

@interface AppDelegate () {
    NSWindowController *_preferencesWindowController;
}

@property (nonatomic, weak) IBOutlet NSWindow *window;
@property (nonatomic) IBOutlet NSWindowController *settingsWindow;
@property (nonatomic, strong) DeckManangerWindowController *managerController;
@property (nonatomic, strong) CardListWindowController *cardListController;

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
    
    if (self.cardListController == nil)
    {
        self.cardListController = [[CardListWindowController alloc] initWithWindowNibName:@"CardListWindow"];
    }
    //[self.cardListController showWindow:self];
    
    if (self.managerController == nil) {
        self.managerController = [[DeckManangerWindowController alloc] initWithWindowNibName:@"DeckManangerWindowController"];
    }
    
    [self.managerController showWindow:self];

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
    [self.preferencesWindowController showWindow:nil];
}

#pragma mark - Public accessors

- (NSWindowController *)preferencesWindowController
{
    if (_preferencesWindowController == nil)
    {
        NSViewController *generalViewController = [[SettingGeneralViewController alloc] initWithNibName:@"SettingLanguageView" bundle:nil];
        NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, nil];
        
        // To add a flexible space between General and Advanced preference panes insert [NSNull null]:
        //     NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, [NSNull null], advancedViewController, nil];
        
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
    }
    return _preferencesWindowController;
}


@end
