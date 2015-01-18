//
//  Configuration.m
//  Hearthstone-Deck-Tracker
//
//  Created by Benjamin Michotte on 18/01/15.
//  Copyright (c) 2015 rainy. All rights reserved.
//

#import "Configuration.h"

NSString* const kCountryLanguage = @"country_language";
NSString* const kFadeCards = @"fade_cards";

NSString* const kCountryLanguageChanged = @"country_language_changed";
NSString* const kFadeCardsChanged = @"fade_cards_changed";

@implementation Configuration

+ (instancetype)instance {
    static Configuration *configuration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configuration = [[self alloc] init];
    });
    return configuration;
}

- (BOOL)isAsiaLanguage {
    return [self.countryLanguage containsString:@"zh"];
}

- (NSString *)countryLanguage {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCountryLanguage];
}

- (void)setCountryLanguage:(NSString *)countryLanguage {
    [[NSUserDefaults standardUserDefaults] setObject:countryLanguage forKey:kCountryLanguage];
}

- (BOOL)fadeCards {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFadeCards];
}

- (void)setFadeCards:(BOOL)fadeCards {
    [[NSUserDefaults standardUserDefaults] setBool:fadeCards forKey:kFadeCards];
}

@end
