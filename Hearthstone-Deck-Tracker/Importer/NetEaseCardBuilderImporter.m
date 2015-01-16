//
//  NetEaseCardBuilderImporter.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/11.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "NetEaseCardBuilderImporter.h"
#import "SystemHelper.h"
#import "CardModel.h"
#import "SBJson4.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "TFHpple.h"

@implementation NetEaseCardBuilderImporter

+ (void)importDockerWithId:(NSString*)dockerId
                   success:(void (^)(NSArray*))success
                      fail:(void (^)(NSString*))fail {
    NSString* query = [NSString stringWithFormat:@"http://www.hearthstone.com.cn/cards/builder/%@", dockerId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *loginRequest  = [manager GET:query parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TFHpple * doc       = [TFHpple hppleWithHTMLData:responseObject];
        NSArray * contentString  = [doc searchWithXPathQuery:@"//*[@id =\'content\']"];
        NSString *cardString;
        if ([contentString count] > 0) {
            TFHppleElement *content = contentString[0];
            cardString = [[content attributes] objectForKey:@"value"];
        }
        else {
            fail(@"Wrong build Id");
            return;
        }

        NSDictionary * trans = [NetEaseCardBuilderImporter transDictionary];
        NSMutableDictionary *result = [NSMutableDictionary new ];
        NSArray *cards = [cardString componentsSeparatedByString:@";"];
        for (NSString* card in cards) {
            NSArray *cardDetail = [card componentsSeparatedByString:@":"];
            result[trans[cardDetail[0]]] =  cardDetail[1];
        }
        
        NSMutableArray *cardsInDocker = [NSMutableArray new];
        for (NSString* cardName in [result allKeys]) {
            CardModel *card = [CardModel cardByEnglishName:cardName ofCountry:@"zhCN"];
            card.count = [result[cardName] intValue];
            [cardsInDocker addObject:card];
        }
        
        NSArray *sortedCards = [CardModel sortCards:cardsInDocker];

        success(sortedCards);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail([error localizedDescription]);
    }];
    
    [loginRequest start];
}

+ (NSDictionary*)transDictionary {
    static NSMutableDictionary *map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SBJson4Parser* parser = [SBJson4Parser multiRootParserWithBlock:^(id item, BOOL *stop) {
            map = [NSMutableDictionary new];
            NSDictionary *res = (NSDictionary *)item;
            for (NSString* cardCatagory in [res allKeys]) {
                NSDictionary *cards = res[cardCatagory];
                for (NSString* cardId in [cards allKeys]) {
                    NSDictionary *card = cards[cardId];
                    map[cardId] = card[@"name"];
                    if([CardModel cardByEnglishName:card[@"name"] ofCountry:@"zhCN"] == NULL) {
                        NSLog(@"%@ name is not card", card[@"name"]);
                    }
                }
            }
        } errorHandler:^(NSError *error) {
            
        }];
        
        NSString *filePath = [NSString stringWithFormat:@"%@/Files/cards.json", [SystemHelper resourcesPath]];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [parser parse:data];
    });

    return map;
}

@end
