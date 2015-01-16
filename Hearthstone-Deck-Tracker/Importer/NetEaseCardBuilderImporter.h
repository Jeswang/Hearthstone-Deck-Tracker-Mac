//
//  NetEaseCardBuilderImporter.h
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/11.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetEaseCardBuilderImporter : NSObject

+ (void)importDockerWithId:(NSString*)dockerId
                   success:(void (^)(NSArray*))success
                      fail:(void (^)(NSString*))fail;

@end
