//
//  DeckModel.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/5/9.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "DeckModel.h"

@implementation CardItem
@end

@implementation DeckModel

+ (DeckModel *)deckWithDeckName:(NSString *)title {
    DeckModel *newDeck = [DeckModel new];
    newDeck.name = title;
    return newDeck;
}

@end
