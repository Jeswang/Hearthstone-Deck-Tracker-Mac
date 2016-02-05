//
//  LogAnalyzer.h
//  hearth
//
//  Created by Simon Andersson on 05/08/14.
//  Copyright (c) 2014 hiddencode.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hearthstone.h"

extern NSString *const CARD_ACTIONS_PATTERN;
extern NSString *const GOT_COIN_PATTERN;
extern NSString *const HERO_PATTERN;
extern NSString *const GAME_START_PATTERN;

@interface LogAnalyzer : NSObject

- (void)analyzeLine:(NSString *)line;

@property (nonatomic, copy) void(^playerDidDrawCard)(Player player, NSString *cardID);
@property (nonatomic, copy) void(^playerDidReturnDeckCard)(Player player, NSString *cardID);
@property (nonatomic, copy) void(^playerDidDiscardCard)(Player player, NSString *cardID);
@property (nonatomic, copy) void(^playerDidPlayCard)(Player player, NSString *cardID);
@property (nonatomic, copy) void(^playerDidReturnHandCard)(Player player, NSString *cardID);

@property (nonatomic, copy) void(^gameDidStart)(Player player);
@property (nonatomic, copy) void(^playerDidDie)(Player player);
@property (nonatomic, copy) void(^playerGotCoin)(Player player);
@property (nonatomic, copy) void(^playerHero)(Player player, NSString *heroId);

@end
