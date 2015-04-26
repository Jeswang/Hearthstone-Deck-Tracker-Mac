//
//  RealmGenerator.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/11.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "RealmGenerator.h"
#import <objc/message.h>
#import "SBJson4.h"
#import "CardModel.h"

@implementation RealmGenerator

+ (void)generateCardRealm {
    static NSString *pathTemplate = @"/Users/jeswang/Documents/App/Hearthstone-Deck-Tracker/Hearthstone-Deck-Tracker-Mac/Hearthstone-Deck-Tracker/CardJs/cardsDB.%@.json";
    
    NSArray *langs = @[@"deDE",
                      @"enGB",
                      @"enUS",
                      @"esES",
                      @"esMX",
                      @"frFR",
                      @"itIT",
                      @"koKR",
                      @"plPL",
                      @"ptBR",
                      @"ptPT",
                      @"ruRU",
                      @"zhCN",
                      @"zhTW"
                      ];
    RLMRealm *realm = [RLMRealm realmWithPath:@"/Users/jeswang/Documents/App/Hearthstone-Deck-Tracker/Hearthstone-Deck-Tracker-Mac/Hearthstone-Deck-Tracker/Files/cards.realm"];

    for (NSString *lang in langs) {
        SBJson4Parser* parser = [SBJson4Parser multiRootParserWithBlock:^(id item, BOOL *stop) {
            NSString *localLang = [lang copy];
            NSArray * validCardSet = @[
                                       @"Basic",
                                       @"Reward",
                                       @"Expert",
                                       @"Classic",
                                       @"Promotion",
                                       @"Curse of Naxxramas",
                                       @"Goblins vs Gnomes",
                                       @"Blackrock Mountain"
                                       ];
            NSDictionary * dict = (NSDictionary *)item;
            
            [realm beginWriteTransaction];

            for (NSString *set in validCardSet) {
                NSArray *cards = [dict objectForKey:set];
                for(NSDictionary *card in cards) {
                    NSLog(@"%@", card[@"name"]);
                    CardModel *cardModel = [CardModel new];
                    
                    cardModel.cost = [card[@"cost"] longLongValue];
                    cardModel.collectible = [card[@"collectible"] boolValue];
                    cardModel.lang = localLang;
                    
                    NSDictionary *mapping = [CardModel JsonMapping];
                    for (NSString* key in [mapping allKeys]) {
                        id value = card[key];
                        if (value) {
                            [cardModel setValue:value forKey:mapping[key]];
                        }
                    }
                    [realm addObject:cardModel];
                }
            }
            
            [realm commitWriteTransaction];
            
        } errorHandler:^(NSError *error) {
            
        }];
        
        NSString *filePath = [NSString stringWithFormat:pathTemplate, lang];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [parser parse:data];
    }
}



@end
