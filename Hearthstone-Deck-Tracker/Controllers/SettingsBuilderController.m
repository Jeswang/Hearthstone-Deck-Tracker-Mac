//
//  SettingsBuilderController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/16.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "SettingsBuilderController.h"

@interface SettingsBuilderController ()

@property IBOutlet NSTextField *status;
@property IBOutlet NSProgressIndicator *indicator;

@end

@implementation SettingsBuilderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}


- (IBAction)cancel:(id)sender {
    NSWindow  *window = [[self view] window];
    [window orderOut:window];
}

- (IBAction)update:(id)sender {
    NSWindow  *window = [[self view] window];
    [window orderOut:window];
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSLog(@"Hello");
}

@end
