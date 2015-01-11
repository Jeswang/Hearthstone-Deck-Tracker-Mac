//
//  SystemHelper.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/11.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "SystemHelper.h"

@implementation SystemHelper

+ (NSString*)cardRealmPath {
    static NSString *absPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *appBundle = [NSBundle mainBundle];
        absPath = [appBundle pathForResource:@"cards" ofType:@"realm" inDirectory:@"Files"];
        NSLog(@"%@", absPath);
    });
    return absPath;
}

+ (NSString*)resourcesPath {
    static NSString *absPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *appBundle = [NSBundle mainBundle];
        absPath = [NSString stringWithFormat:@"%@/Contents/Resources", [appBundle bundlePath]];
    });
    return absPath;
}

@end
