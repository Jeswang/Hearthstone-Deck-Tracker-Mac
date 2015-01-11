//
//  AppDelegate.h
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/9.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (void)updateWithCards:(NSArray *)cards;

@property (nonatomic, strong) NSMutableArray *updateList;

@end

