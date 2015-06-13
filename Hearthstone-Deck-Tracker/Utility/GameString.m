//
//  GameString.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/6/12.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "GameString.h"

@implementation GameString

+ (NSDictionary *)defaultPropertyValues {
    return @{
             @"key": @"",
             @"value": @"",
             @"lang": @""
             };
}

+ (NSString *)valueForKey:(NSString *)key {
    NSString *lang = COUNTRY;
    if ([lang isEqualTo:@"enGB"]) {
        lang = @"enUS";
    }
    else if ([lang isEqualTo:@"ptPT"]) {
        lang = @"ptBR";
    }

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"key = %@ AND lang = %@", key, lang];
    RLMResults* gameStrings = [GameString objectsInRealm:CARD_REALM withPredicate:pred];
    if (gameStrings.count > 0) {
        return [gameStrings[0] value];
    }
    else {
        return key;
    }
}
@end
