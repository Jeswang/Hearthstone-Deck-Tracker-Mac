//
//  Configuration.m
//  Hearthstone-Deck-Tracker
//
//  Created by Benjamin Michotte on 18/01/15.
//  Copyright (c) 2015 rainy. All rights reserved.
//

#import "Configuration.h"

NSString* const kCountryLanguage = @"country_language";

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

@end
