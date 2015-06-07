//
//  NetEaseCardBuilderImporter.h
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/11.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DeckModel;

@interface NetEaseCardBuilderImporter : NSObject

+ (void)importDocker:(NSString *)site
              withId:(NSString *)dockerId
             success:(void (^)(DeckModel *))success
                fail:(void (^)(NSString *))fail;

@end
