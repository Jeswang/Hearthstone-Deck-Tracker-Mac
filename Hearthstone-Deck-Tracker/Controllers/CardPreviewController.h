//
//  CardPreviewController.h
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/17.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSImageView+WebCache.h"

@interface CardPreviewController : NSWindowController<NSImageViewWebCacheDelegate>

- (void)loadCardByCardId:(NSString *)cardId;

@end
