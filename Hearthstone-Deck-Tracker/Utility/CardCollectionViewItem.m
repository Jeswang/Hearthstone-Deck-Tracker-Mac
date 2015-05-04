//
//  CardCollectionViewItem.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/5/3.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardCollectionViewItem.h"

#define LOCAL_IMAGE_TEMPLATE @"/Users/jeswang/Documents/App/Hearthstone_Cards/resources/data/Images/20150109/%@.png"

@interface CardCollectionViewItem ()
@property (nonatomic, strong) NSImage *cardImage;
@end

@implementation CardCollectionViewItem

- (void)setCardImageWithId:(NSString *)cardId {
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:LOCAL_IMAGE_TEMPLATE, cardId]];
    self.cardImage = image;
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
