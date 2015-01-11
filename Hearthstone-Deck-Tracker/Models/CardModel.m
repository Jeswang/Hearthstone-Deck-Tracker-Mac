//
//  CardModel.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/11.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardModel.h"

@implementation StringObject
@end

@implementation CardModel

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{
             @"count": @0,
             @"health": @0,
             @"inHandCount": @0,
             @"isStolen": @false,
             @"justDrawn": @false,
             @"wasDiscarded": @false,
             @"localizedName":@"",
             @"lang":@"",
             @"name":@"",
             @"cardId":@"",
             @"cardType":@"",
             @"text":@"",
             @"playerClass":@"",
             @"rarity":@"",
             @"faction":@"",
             @"flavor":@"",
             @"collectible":@false,
             @"howToGet":@"",
             @"artist":@"",
             @"cost":@0
            };
}


+ (NSDictionary *)JsonMapping {
    return @{
             @"name":@"name",
             @"id":@"cardId",
             @"type":@"cardType",
             @"text":@"text",
             @"playerClass":@"playerClass",
             @"rarity":@"rarity",
             @"faction":@"faction",
             @"flavor":@"flavor",
             @"howToGet":@"howToGet",
             @"artist":@"artist",
             };
}

- (NSString*)englishName {
    CardModel *englishCard = [CardModel cardById:self.cardId ofCountry:@"enUS"];
    NSString *englishName = englishCard.name;
    return englishName;
}

+ (NSString*)absPath {
    static NSString *absPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *appBundle = [NSBundle mainBundle];
        absPath = [appBundle pathForResource:@"cards" ofType:@"realm" inDirectory:@"Files"];
        NSLog(@"%@", absPath);
    });
    return absPath;
}

+ (CardModel *)cardById:(NSString*)cardId ofCountry:(NSString*)country {

    RLMRealm* realm = [RLMRealm realmWithPath:self.absPath];

    RLMResults* cards;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cardId = %@ AND lang = %@",
                         cardId, country];
    cards = [CardModel objectsInRealm:realm withPredicate:pred];
    
    return [cards objectAtIndex:0];
}

+ (NSArray *)actualCards {
    RLMRealm* realm = [RLMRealm realmWithPath:self.absPath];
    
    RLMResults* cards;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"collectible = 1 AND cardType != 'Hero' AND lang = %@", @"zhCN"];
    cards = [[CardModel objectsInRealm:realm withPredicate:pred] sortedResultsUsingProperty:@"cost" ascending:YES];
    
    NSMutableArray *result = [NSMutableArray new];
    for (CardModel* card in cards) {
        [result addObject:card];
    }
    return result;
}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
