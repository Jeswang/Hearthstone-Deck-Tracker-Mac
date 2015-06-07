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
    newDeck.totalCount = 0;
    
    [REALM beginWriteTransaction];
    [REALM addObject:newDeck];
    [REALM commitWriteTransaction];

    return newDeck;
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"type": @""};
}


- (CardItem *)findItemById:(NSString *)cardId {
    for(CardItem *item in self.cards) {
        if ([cardId isEqualToString:item.cardId]) {
            return item;
        }
    }
    return nil;
}

- (void)addCard:(NSString*)cardId {
    [REALM beginWriteTransaction];
    CardItem *item = [self findItemById:cardId];
    if (item) {
        item.count += 1;
    }
    else {
        item = [CardItem new];
        item.cardId = cardId;
        item.count = 1;
        [self.cards addObject:item];
    }
    self.totalCount += 1;
    [REALM commitWriteTransaction];
}
- (void)removeCard:(NSString*)cardId {
    [REALM beginWriteTransaction];
    CardItem *item = [self findItemById:cardId];
    if (item) {
        item.count -= 1;
        if (item.count == 0) {
            NSUInteger index = [self.cards indexOfObject:item];
            [self.cards removeObjectAtIndex:index];
        }
    }
    self.totalCount -= 1;
    [REALM commitWriteTransaction];
}

+ (NSMutableArray *)decks {
    NSMutableArray *decks = [NSMutableArray new];
    RLMResults *results = [DeckModel allObjects];
    for(DeckModel *deck in results) {
        [decks addObject:deck];
    }
    return decks;
}

+ (void)deleteDeck:(DeckModel *)deck {
    [REALM beginWriteTransaction];
    for (CardItem *item in deck.cards) {
        [REALM deleteObject:item];
    }
    [REALM deleteObject:deck];
    [REALM commitWriteTransaction];
    
}

@end
