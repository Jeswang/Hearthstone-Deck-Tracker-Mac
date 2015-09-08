//
//  main.m
//  remove-uncollectible-card-images
//
//  Created by jeswang on 15/6/14.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "CardModel.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        [RLMRealm setSchemaVersion:4 withMigrationBlock:^(RLMMigration *migration, NSUInteger oldSchemaVersion) {
            
        }];
        
        NSMutableSet *cardSet = [NSMutableSet new];
        NSArray *cards = [CardModel actualCards];
        for (CardModel* card in cards) {
            NSLog(@"%@", card.cardId);
            NSString *cardFileName = [NSString stringWithFormat:@"%@.png", card.cardId];
            [cardSet addObject:cardFileName];
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *bundleURL = [NSURL URLWithString:IMAGE];
        NSArray *contents = [fileManager contentsOfDirectoryAtURL:bundleURL
                                       includingPropertiesForKeys:@[]
                                                          options:NSDirectoryEnumerationSkipsHiddenFiles
                                                            error:nil];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension == 'png'"];
        int count = 0;
        for (NSURL *fileURL in [contents filteredArrayUsingPredicate:predicate]) {
            // Enumerate each .png file in directory
            //NSLog(@"%@", [[fileURL pathComponents] lastObject]);
            NSString *cardFileName = [[fileURL pathComponents] lastObject];
            if ([cardSet containsObject:cardFileName]) {
                count++;
                NSLog(@"%d", count);
            }
            else {
                NSError *error = nil;
                if (![fileManager removeItemAtURL:fileURL error:&error]) {
                    NSLog(@"[Error] %@ (%@)", error, fileURL);
                }
            }
        }
    }
    return 0;
}
