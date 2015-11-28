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
#import "GameString.h"

@implementation RealmGenerator


static NSString *allSetCardPathTemplate = @"/Users/jeswang/Documents/App/Hearthstone-Deck-Tracker/Hearthstone-Deck-Tracker-Mac/Hearthstone-Deck-Tracker/CardJs/AllSetsAllLanguages.json";

static NSString *cardPathTemplate = @"/Users/jeswang/Documents/App/Hearthstone-Deck-Tracker/Hearthstone-Deck-Tracker-Mac/Hearthstone-Deck-Tracker/CardJs/cardsDB.%@.json";

static NSString *stringFileTemplate = @"/Applications/Hearthstone/Strings/%@/GLOBAL.txt";


+ (void)generateCardRealmFromAllSet {
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

     RLMRealm *realm = UPDATE_REALM;
    
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
    
    SBJson4Parser* parser = [SBJson4Parser multiRootParserWithBlock:^(id item, BOOL *stop) {
        NSArray * validCardSet = @[
                                   @"Basic",
                                   @"Reward",
                                   @"Expert",
                                   @"Classic",
                                   @"Promotion",
                                   @"Curse of Naxxramas",
                                   @"Goblins vs Gnomes",
                                   @"Blackrock Mountain",
                                   @"The Grand Tournament",
                                   @"League of Explorers"
                                   ];
        NSDictionary * dict = (NSDictionary *)item;
        
        [realm beginWriteTransaction];
        
        for (NSString *lang in langs) {
            NSDictionary *langDic = [dict objectForKey:lang];
            for (NSString *set in validCardSet) {
                NSArray *cards = [langDic objectForKey:set];
                for(NSDictionary *card in cards) {
                    NSLog(@"%@", card[@"name"]);
                    CardModel *cardModel = [CardModel new];
                    
                    cardModel.cost = [card[@"cost"] longLongValue];
                    cardModel.collectible = [card[@"collectible"] boolValue];
                    cardModel.lang = lang;
                    cardModel.mechanics = (RLMArray<StringObject> *)[[RLMArray alloc] initWithObjectClassName:@"StringObject"];
                    
                    if ([[card allKeys] containsObject:@"mechanics"]) {
                        NSMutableArray *mechanics = card[@"mechanics"];
                        for (NSString *mechanic in mechanics) {
                            StringObject *obj = [StringObject stringForValue:mechanic];
                            [cardModel.mechanics addObject:obj];
                        }
                    }
                    
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
        }
        
        [realm commitWriteTransaction];
        
    } errorHandler:^(NSError *error) {
        
    }];
    
    NSString *filePath = allSetCardPathTemplate;
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    [parser parse:data];

    [RealmGenerator generateLines];
}

+ (void)generateLines {
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
    
     RLMRealm *realm = UPDATE_REALM;
    for (NSString *lang in langs) {
        NSString *filePath = [NSString stringWithFormat:stringFileTemplate, lang];
        NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *lines = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
        
        for (NSString *line in lines) {
            NSArray *parts = [line componentsSeparatedByString:@"\t"];
            if ([parts count] > 1) {
                GameString *string = [GameString new];
                string.key = parts[0];
                string.value = [line stringByReplacingCharactersInRange:NSMakeRange(0, string.key.length+1) withString:@""];
                string.lang = lang;
                [realm beginWriteTransaction];
                [realm addObject:string];
                [realm commitWriteTransaction];
            }
        }
    }
}

+ (void)generateCardRealm {
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
    
    RLMRealm *realm = UPDATE_REALM;
    
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
    
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
                                       @"Blackrock Mountain",
                                       @"The Grand Tournament"
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
                    cardModel.mechanics = (RLMArray<StringObject> *)[[RLMArray alloc] initWithObjectClassName:@"StringObject"];
                    
                    if ([[card allKeys] containsObject:@"mechanics"]) {
                        NSMutableArray *mechanics = card[@"mechanics"];
                        for (NSString *mechanic in mechanics) {
                            StringObject *obj = [StringObject stringForValue:mechanic];
                            [cardModel.mechanics addObject:obj];
                        }
                    }
                    
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
        
        NSString *filePath = [NSString stringWithFormat:cardPathTemplate, lang];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [parser parse:data];
    }
    
    [RealmGenerator generateLines];
}



@end
