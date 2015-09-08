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

@implementation CardFilter {
    
}

+ (CardFilter *)filterWithName:(NSString *)name label:(NSString *)label dict:(NSDictionary *)dict {
    CardFilter *filter = [CardFilter new];
    filter.name = name;
    filter.label = label;
    filter.dict = dict;
    filter.selectedKey = @"";
    return filter;
}

- (RLMResults *)filterdResult:(RLMResults *)input {
    if ([self.selectedKey isEqualTo:@""] ||
        [self.selectedKey isEqualTo:@"all"] ||
        [self.selectedKey isEqualTo:@"0 all"]) {
        return input;
    }
    
    NSString *trueKey = [[self.selectedKey componentsSeparatedByString:@" "] lastObject];
    
    if ([self.name isEqualTo:@"name"]) {
        return [input objectsWhere:@"%K CONTAINS[c] %@", self.name, trueKey];
    }
    
    if ([self.name isEqualTo:@"cost"]) {
        if ([trueKey isEqualTo:@"7"]) {
            return [input objectsWhere:@"%K >= %d", self.name, [trueKey integerValue]];
        }
        else {
            return [input objectsWhere:@"%K = %d", self.name, [trueKey integerValue]];
        }
    }
    
    if ([self.name isEqualTo:@"playerClass"] && [trueKey isEqualTo:@"Neutral"]) {
        trueKey = @"";
    }
    
    return [input objectsWhere:@"%K = %@", self.name, trueKey];
}

@end

@implementation StringObject

+ (StringObject *)stringForValue:(NSString *)value {
    RLMResults *strings = [StringObject objectsInRealm:UPDATE_REALM where:@"value = %@", value];
    if ([strings count] != 0) {
        return strings[0];
    }
    else {
        //[UPDATE_REALM beginWriteTransaction];
        StringObject *obj = [StringObject new];
        obj.value = value;
        //[UPDATE_REALM addObject:obj];
        //[UPDATE_REALM commitWriteTransaction];
        return obj;
    }
}

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
             @"cost":@0,
             @"race":@""
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
             @"race":@"race",
             };
}

- (NSString*)englishName {
    CardModel *englishCard = [CardModel cardById:self.cardId ofCountry:@"enUS"];
    NSString *englishName = englishCard.name;
    return englishName;
}

+ (CardModel *)cardById:(NSString*)cardId ofCountry:(NSString*)country {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cardId = %@ AND lang = %@",
                         cardId, country];
    RLMResults* cards = [CardModel objectsInRealm:CARD_REALM withPredicate:pred];

    if ([cards count] > 0) {
        CardModel *card = [[cards objectAtIndex:0] deepCopy];
        return card;
    }
    else {
        return NULL;
    }
}

+ (CardModel *)cardByEnglishName:(NSString*)name ofCountry:(NSString*)country {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = %@ AND lang = %@",
                         name, @"enUS"];
    RLMResults* cards = [CardModel objectsInRealm:CARD_REALM withPredicate:pred];
    
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

+ (NSArray *)cardWithFilters:(NSArray *)filters {
    RLMResults *cards = [CardModel actualCardResults];
    for (CardFilter *filter in filters) {
        cards = [filter filterdResult:cards];
    }
    return [CardModel arrayFromResult:cards];
}

+ (RLMResults *)resultWithFilter:(RLMResults *)input {
    return input;
}

+ (NSArray *)arrayFromResult:(RLMResults *)cards{
    NSMutableArray *result = [NSMutableArray new];
    for (CardModel* card in cards) {
        [result addObject:[card deepCopy]];
    }
    return result;
}

+ (RLMResults *)actualCardResults {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"collectible = 1 AND cardType != 'Hero' AND lang = %@", COUNTRY];
    RLMResults* cards = [[CardModel objectsInRealm:CARD_REALM withPredicate:pred] sortedResultsUsingProperty:@"cost" ascending:YES];
    return cards;
}

+ (NSArray *)actualCards {
    RLMResults* cards = [CardModel actualCardResults];
    return [CardModel arrayFromResult:cards];
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

+ (void)sortCards:(NSMutableArray*)cards {
    [cards sortUsingSelector:@selector(compare:)];
}

@end
