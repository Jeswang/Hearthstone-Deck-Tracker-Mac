//
//  DeckModel.h
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/5/9.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Realm/Realm.h>

@class DeckModel;

// Dog model
@interface CardItem : RLMObject
@property NSString *cardId;
@property NSInteger count;
@property DeckModel *owner;
@end

RLM_ARRAY_TYPE(CardItem) // define RLMArray<Dog>

@interface DeckModel : RLMObject
@property NSString *name;
@property NSString *type;
@property NSInteger totalCount;
@property RLMArray<CardItem> *cards;


@end

// This protocol enables typed collections. i.e.:
// RLMArray<DeckModel>
RLM_ARRAY_TYPE(DeckModel)
