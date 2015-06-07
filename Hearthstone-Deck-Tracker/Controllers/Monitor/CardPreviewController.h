//
//  CardPreviewController.h
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/17.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CardPreviewController : NSWindowController

- (void)loadCardByCardId:(NSString *)cardId;

@end
