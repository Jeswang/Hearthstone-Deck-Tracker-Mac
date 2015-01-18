//
//  CardModel.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/11.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardModel.h"
#import "SystemHelper.h"
#import "RLMObject+Copying.h"
#import "Configuration.h"

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

+ (CardModel *)cardById:(NSString*)cardId ofCountry:(NSString*)country {

    RLMRealm* realm = [RLMRealm realmWithPath:[SystemHelper cardRealmPath]];

    RLMResults* cards;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cardId = %@ AND lang = %@",
                         cardId, country];
    cards = [CardModel objectsInRealm:realm withPredicate:pred];

    if ([cards count] > 0) {
        CardModel *card = [[cards objectAtIndex:0] deepCopy];
        return card;
    }
    else {
        return NULL;
    }
}

+ (CardModel *)cardByEnglishName:(NSString*)name ofCountry:(NSString*)country {
    
    RLMRealm* realm = [RLMRealm realmWithPath:[SystemHelper cardRealmPath]];
    
    RLMResults* cards;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = %@ AND lang = %@",
                         name, @"enUS"];
    cards = [CardModel objectsInRealm:realm withPredicate:pred];
    
    if ([cards count] > 1) {
        NSPredicate *predValid = [NSPredicate predicateWithFormat:@"collectible = 1 AND cardType != 'Hero'"];
        cards = [cards objectsWithPredicate:predValid];
    }
    
    if ([cards count] > 0) {
        CardModel *card = [cards objectAtIndex:0];
        return [CardModel cardById:card.cardId ofCountry:country];
    }
    else {
        return NULL;
    }
}


+ (NSArray *)actualCards {
    RLMRealm* realm = [RLMRealm realmWithPath:[SystemHelper cardRealmPath]];
    
    RLMResults* cards;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"collectible = 1 AND cardType != 'Hero' AND lang = %@", [Configuration instance].countryLanguage];
    cards = [[CardModel objectsInRealm:realm withPredicate:pred] sortedResultsUsingProperty:@"cost" ascending:YES];
    
    NSMutableArray *result = [NSMutableArray new];
    for (CardModel* card in cards) {
        [result addObject:[card deepCopy]];
    }
    return result;
}

- (NSComparisonResult)compare:(CardModel *)otherObject {
    NSComparisonResult result = [@(self.cost) compare:@(otherObject.cost)];
    // first order by cost
    if (result != NSOrderedSame) {
        return result;
    }
    // then by name
    return [self.name compare:otherObject.name];
}

+ (NSArray*)sortCards:(NSMutableArray*)cards {
    return [cards sortedArrayUsingSelector:@selector(compare:)];
}

@end
