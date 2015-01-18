//
//  LogAnalyzer.h
//  hearth
//
//  Created by Simon Andersson on 05/08/14.
//  Copyright (c) 2014 hiddencode.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hearthstone.h"

@interface LogAnalyzer : NSObject

- (void)analyzeLine:(NSString *)line;

@property (nonatomic, copy) void(^playerDidDrawCard)(Player player, NSString *cardID);
@property (nonatomic, copy) void(^playerDidDiscardCard)(Player player, NSString *cardID);
@property (nonatomic, copy) void(^playerDidPlayCard)(Player player, NSString *cardID);
@property (nonatomic, copy) void(^playerDidReturnCard)(Player player, NSString *cardID);
@property (nonatomic, copy) void(^playerDidDie)(Player player);
@property (nonatomic, copy) void(^playerGotCoin)(Player player);
@property (nonatomic, copy) void(^playerHero)(Player player, NSString *heroId);

@end
