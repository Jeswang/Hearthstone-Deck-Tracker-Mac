//
//  CardPreviewController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/17.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardPreviewController.h"

@interface CardPreviewController ()
@property(nonatomic, weak) IBOutlet NSImageView *cardImage;
@end

@implementation CardPreviewController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.cardImage setImageScaling:NSImageScaleProportionallyUpOrDown];
}

- (void)loadCardByCardId:(NSString *)cardId {
    NSString *country = @"en";
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@/%@.png", IMAGE, country, cardId];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    [self.cardImage setImage:image];
    return;
}

@end
