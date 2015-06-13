//
//  CardListWindowController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/15.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardListWindowController.h"
#import "CardListViewController.h"
#import "ImportWindowController.h"
#import "Masonry.h"

@interface CardListWindowController ()

@property(nonatomic, weak) IBOutlet NSView *container;
@property(nonatomic, strong) ImportWindowController *settingController;
@property(nonatomic, strong) CardListViewController *cardListController;

@end

@implementation CardListWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.delegate = self;
    [self.window setLevel:NSScreenSaverWindowLevel];
    
    [self loadCardView];
}

- (void)loadCardView {
    if (self.cardListController == nil) {
        self.cardListController = [[CardListViewController alloc] init];
        self.cardListController.isManager = false;
    }
    [self.container addSubview:[self.cardListController view]];
    
    [self.cardListController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.container);
    }];
    
}

- (void)windowWillMiniaturize:(NSNotification *)notification {
    [self.window setLevel:NSNormalWindowLevel];
}

- (void)windowDidMiniaturize:(NSNotification *)notification {
    [self.window setLevel:NSScreenSaverWindowLevel];
}


- (IBAction)openBuilder:(id)sender {
    //[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.hearthstone.com.cn/cards/builder/"]];
    [APP openManger:nil];
}

- (IBAction)openImport:(id)sender {
    if (self.settingController == nil) {
        self.settingController = [[ImportWindowController alloc] initWithWindowNibName:@"ImportWindow"];
        NSWindow * fakeWindow = [self.settingController window];
        [fakeWindow description];
    }
    
    [self.window beginSheet:self.settingController.window completionHandler:^(NSModalResponse returnCode) {
        
    }];
}
- (IBAction)openSetting:(id)sender {
    [APP openSettings:nil];
}

@end
