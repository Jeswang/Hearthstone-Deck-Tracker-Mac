//
//  Configuration.h
//  Hearthstone-Deck-Tracker
//
//  Created by Benjamin Michotte on 18/01/15.
//  Copyright (c) 2015 rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

// keys for settings
extern NSString* const kCountryLanguage;
extern NSString* const kFadeCards;

// notification names
extern NSString* const kCountryLanguageChanged;
extern NSString* const kFadeCardsChanged;

@interface Configuration : NSObject

@property(nonatomic, strong) NSString *countryLanguage;
@property(nonatomic, getter=isAsiaLanguage, readonly) BOOL asiaLanguage;
@property(nonatomic) BOOL fadeCards;

+ (instancetype)instance;

@end
