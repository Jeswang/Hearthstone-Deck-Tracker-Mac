//
//  ViewController.h
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/9.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CardListDelegate <NSObject>

- (void)updateWithCards:(NSArray*)cards;

@end

@interface CardListViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, CardListDelegate>


@end

