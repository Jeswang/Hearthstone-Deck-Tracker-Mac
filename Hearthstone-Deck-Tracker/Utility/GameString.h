//
//  GameString.h
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/6/12.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface GameString : RLMObject

@property NSString *key;
@property NSString *value;
@property NSString *lang;
+ (NSString *)valueForKey:(NSString *)key;

@end
