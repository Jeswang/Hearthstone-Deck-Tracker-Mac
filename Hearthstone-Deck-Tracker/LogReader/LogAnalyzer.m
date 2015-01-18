//
//  LogAnalyzer.m
//  hearth
//
//  Created by Simon Andersson on 05/08/14.
//  Copyright (c) 2014 hiddencode.me. All rights reserved.
//

#import "LogAnalyzer.h"

@interface NSRegularExpression (StringAtIndex)
- (NSString *)matchWithString:(NSString *)string atIndex:(int)idx;
@end

@implementation NSRegularExpression (StringAtIndex)

- (NSString *)matchWithString:(NSString *)string atIndex:(int)idx {
    NSArray *matches = [self matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *match in matches) {
        if (match.numberOfRanges-1 < idx) {
            return nil;
        }
        
        NSRange matchRange = [match rangeAtIndex:idx];
        NSString *matchString = [string substringWithRange:matchRange];
        return matchString;
    }
    
    return nil;
}

@end

@interface NSString (Contains)
- (BOOL)contains:(NSString *)search;
@end

@implementation NSString (Contains)

- (BOOL)contains:(NSString *)search {
    return [self rangeOfString:search].location != NSNotFound;
}

@end

@implementation LogAnalyzer

- (void)analyzeLine:(NSString *)line {
    if ([[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return;
    }
    
    static NSString *pattern = @"ProcessChanges.*cardId=(\\w+).*zone from (.*) -> (.*)";
    NSError *error = nil;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    if ([regexp numberOfMatchesInString:line options:0 range:NSMakeRange(0, line.length)] != 0) {
        
        NSString *cardId = [regexp matchWithString:line atIndex:1];
        NSString *from = [regexp matchWithString:line atIndex:2];
        NSString *to = [regexp matchWithString:line atIndex:3];
        
        if([from contains:@"FRIENDLY DECK"] && [to contains:@"GRAVEYARD"]) {
            _playerDidDiscardCard(PlayerMe, cardId);
        }
        
        if([from contains:@"FRIENDLY DECK"] && [to contains:@"FRIENDLY HAND"]) {
            _playerDidDrawCard(PlayerMe, cardId);
        }
        
        if([from contains:@"FRIENDLY HAND"] && [to contains:@"FRIENDLY PLAY"]) {
            _playerDidPlayCard(PlayerMe, cardId);
        }
        
        if([from contains:@"FRIENDLY PLAY"] && [to contains:@"FRIENDLY HAND"]) {
            _playerDidReturnCard(PlayerMe, cardId);
        }
        
        //NSLog(@"%@ to %@", from, to);
    }
    [self analyzeForCoin:line];
    [self analyzeForHero:line];
    [self analyzeForGameState:line];
}

- (void)analyzeForGameState:(NSString *)line {
    if ([line hasPrefix:@"[Asset]"]) {
        if ([[line lowercaseString] contains:@"victory_screen_start"]) {
            NSLog(@"Victory!");
            _playerDidDie(PlayerOpponent);
        }
        else if([[line lowercaseString] contains:@"defeat_screen_start"]) {
            NSLog(@"Defeat");
            _playerDidDie(PlayerMe);
        }
    }
}

- (void)analyzeForCoin:(NSString *)line {
    static NSString *pattern = @"ProcessChanges.*zonePos=5.*zone from  -> (.*)";
    NSError *error = nil;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    if ([regexp numberOfMatchesInString:line options:0 range:NSMakeRange(0, line.length)] != 0) {
        NSString *to = [regexp matchWithString:line atIndex:1];
        if([to contains:@"FRIENDLY HAND"]) {
            _playerGotCoin(PlayerMe);
        } else if([to contains:@"OPPOSING HAND"]) {
            _playerGotCoin(PlayerOpponent);
        }
    }
}
- (void)analyzeForHero:(NSString *)line {
    static NSString *pattern = @"ProcessChanges.*TRANSITIONING card \\[name=(.*).*zone=PLAY.*cardId=(.*).*player=(\\d)\\] to (.*) \\(Hero\\)";
    NSError *error = nil;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    if ([regexp numberOfMatchesInString:line options:0 range:NSMakeRange(0, line.length)] != 0) {
        NSLog(@"%@", line);
        //NSString *name = [regexp matchWithString:line atIndex:1];
        NSString *cardId = [regexp matchWithString:line atIndex:2];
        //NSString *player = [regexp matchWithString:line atIndex:3];
        NSString *to   = [regexp matchWithString:line atIndex:4];
        
        if([to isEqualToString:@"FRIENDLY PLAY"]) {
            _playerHero(PlayerMe, cardId);
        }
        else {
            _playerHero(PlayerOpponent, cardId);
        }
    }
}

@end
