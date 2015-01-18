//
//  CardCellView.h
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/11.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HoverTableCellView.h"

@class CardModel;

@interface CardCellView : HoverTableCellView

@property CardModel *card;

+ (instancetype)initWithCard:(CardModel*)card;

@end
