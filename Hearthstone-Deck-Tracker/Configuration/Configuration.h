//
//  Configuration.h
//  Hearthstone-Deck-Tracker
//
//  Created by Benjamin Michotte on 18/01/15.
//  Copyright (c) 2015 rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kCountryLanguage;

@interface Configuration : NSObject

@property(nonatomic, strong) NSString *countryLanguage;
@property(nonatomic, getter=isAsiaLanguage, readonly) BOOL asiaLanguage;

+ (instancetype)instance;

@end
