//
//  SettingsBuilderController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/16.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "SettingsBuilderController.h"
#import "NetEaseCardBuilderImporter.h"
#import "AppDelegate.h"

@interface SettingsBuilderController ()

@property IBOutlet NSTextField *status;
@property IBOutlet NSProgressIndicator *indicator;

@property IBOutlet NSButton *cancelButton;
@property IBOutlet NSButton *updateButton;

@property IBOutlet NSTextField *inputField;
@property IBOutlet NSComboBox *siteChooser;
// TODO remove when Settings window will be implemented
@property IBOutlet NSComboBox *languageChooser;

@end

@implementation SettingsBuilderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.indicator setHidden:YES];
    [self.status setHidden:YES];
}


- (IBAction)cancel:(id)sender {    
    NSWindow  *window = [[self view] window];
    [window orderOut:window];
}

- (IBAction)update:(id)sender {
    if ([[self.inputField stringValue] length] == 0) {
        NSLog(@"Please input builder Id");
    }
    else if (![self.siteChooser objectValueOfSelectedItem]) {
        NSLog(@"Should select site");
    }
    else if (![self.languageChooser objectValueOfSelectedItem]) {
        // TODO remove when Settings window will be implemented
        NSLog(@"Should select language");
    }
    else {
        [self.indicator setHidden:NO];
        [self.indicator startAnimation:self];
        [self.status setHidden:NO];
        [self.status setStringValue:@"querying"];

        [NetEaseCardBuilderImporter importDocker:[self.siteChooser objectValueOfSelectedItem]
                                          withId:[self.inputField stringValue]
                                         country:[self.languageChooser objectValueOfSelectedItem]
                                         success:^(NSArray *cards) {
            [self.indicator setHidden:YES];
            [self.status setStringValue:@"success"];

            AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
            [appDelegate updateWithCards:cards];

            NSWindow *window = [[self view] window];
            [window orderOut:window];

        }                                   fail:^(NSString *failReason) {
            [self.indicator setHidden:YES];
            [self.status setStringValue:failReason];
        }];
    }
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSLog(@"Hello");
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Hello");
}

@end
