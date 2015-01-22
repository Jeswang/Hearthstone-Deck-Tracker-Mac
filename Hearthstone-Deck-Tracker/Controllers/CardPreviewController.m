//
//  CardPreviewController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/17.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardPreviewController.h"
#import "NSImageView+WebCache.h"

#define HEARTHHEAD_IMAGE_TEMPLATE @"http://lai1tong.com/cards/CN/%@.png"
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
    
    NSString *imageFilePath = [NSString stringWithFormat:LOCAL_IMAGE_TEMPLATE, cardId];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:imageFilePath]) {
        [self.cardImage setImage:[[NSImage alloc] initWithContentsOfFile:imageFilePath]];
    }
    else {
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:HEARTHHEAD_IMAGE_TEMPLATE, cardId]];
        [self.cardImage setImage:[NSImage imageNamed:@"Card_back-Default"]];
        [self.cardImage setImageURL:imageURL];
    }
}

@end
