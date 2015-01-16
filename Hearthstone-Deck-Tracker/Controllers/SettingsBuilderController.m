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
        NSLog(@"Should input builder Id");
    }
    else {
        [self.indicator setHidden:NO];
        [self.indicator startAnimation:self];
        [self.status setHidden:NO];
        [self.status setStringValue:@"querying"];
        
        
        [NetEaseCardBuilderImporter importDockerWithId:[self.inputField stringValue] success:^(NSArray *cards) {
            [self.indicator setHidden:YES];
            [self.status setStringValue:@"success"];
            
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            [appDelegate updateWithCards:cards];
            
            NSWindow  *window = [[self view] window];
            [window orderOut:window];
            
        } fail:^(NSString *failReason) {
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
