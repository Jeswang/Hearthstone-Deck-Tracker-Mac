//
//  CardCollectionViewItem.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/5/3.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardCollectionViewItem.h"


@interface CardCollectionViewItem ()
@property (nonatomic, strong) NSImage *cardImage;
@property (nonatomic, strong) NSString *cardId;
- (IBAction)click:(id)sender;

@end

@implementation CardCollectionViewItem

- (void)setCardImageWithId:(NSString *)cardId {
    NSString *country = @"en";
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@/%@.png", IMAGE, country, cardId];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    self.cardImage = image;
    self.cardId = cardId;
}


- (IBAction)click:(id)sender {
    NSLog(@"Add Card %@", self.cardId);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCard" object:self.cardId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
