//
//  AppDelegate.h
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/9.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DeckModel;

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (void)updateWithDeck:(DeckModel *)deck;

@property (nonatomic, strong) NSMutableArray *updateList;

- (IBAction)openSettings:(id)sender;
- (IBAction)openManger:(id)sender;
- (IBAction)openTracker:(id)sender;
@end

