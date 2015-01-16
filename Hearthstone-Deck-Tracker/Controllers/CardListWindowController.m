//
//  CardListWindowController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/15.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardListWindowController.h"
#import "SettingBuilderWindowController.h"

@interface CardListWindowController ()

@property(nonatomic, strong) SettingBuilderWindowController *settingController;

@end

@implementation CardListWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setLevel:NSScreenSaverWindowLevel];
}

- (IBAction)openBuilder:(id)sender {
    
}

- (IBAction)openSetting:(id)sender {
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    self.settingController = [sb instantiateControllerWithIdentifier:@"SettingBuilderWindowController"];
    [self.window beginSheet:self.settingController.window completionHandler:^(NSModalResponse returnCode) {
        
    }];
}

@end
