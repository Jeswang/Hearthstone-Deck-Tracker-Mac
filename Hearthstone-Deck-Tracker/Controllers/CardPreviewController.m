//
//  CardPreviewController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/17.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardPreviewController.h"
#import "NSImageView+WebCache.h"

#define HEARTHHEAD_IMAGE_TEMPLATE @"http://wow.zamimg.com/images/hearthstone/cards/enus/original/%@.png"
#define LOCAL_IMAGE_TEMPLATE @"/Users/jeswang/Documents/App/Hearthstone_Cards/resources/data/Images/20150109/%@.png"
@interface CardPreviewController ()
@property(nonatomic, weak) IBOutlet NSImageView *cardImage;
@end

@implementation CardPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.cardImage setImageAlignment:NSImageAlignTopRight];
    [self.cardImage setImageScaling:NSImageScaleProportionallyUpOrDown];
}

- (void)loadCardByCardId:(NSString *)cardId {
    
    //NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:HEARTHHEAD_IMAGE_TEMPLATE, cardId]];
    //[self.cardImage setImage:nil];
    //[self.cardImage setImageURL:imageURL];
    NSString *imageFilePath = [NSString stringWithFormat:LOCAL_IMAGE_TEMPLATE, cardId];
    [self.cardImage setImage:[[NSImage alloc] initWithContentsOfFile:imageFilePath]];
}

@end
