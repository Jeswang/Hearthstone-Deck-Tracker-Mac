//
//  ViewController.h
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/9.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HoverTableCellView.h"

@class DeckModel;

@protocol CardListDelegate <NSObject>

- (void)updateWithDeck:(DeckModel *)deck;
- (void)resetCards;
- (void)removeCard:(NSString *)cardId;
- (void)restoreCard:(NSString *)cardId;

@end

@interface CardListViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, CardListDelegate, HoverCellProtocal>
@property(nonatomic, assign) BOOL isManager;

@end

