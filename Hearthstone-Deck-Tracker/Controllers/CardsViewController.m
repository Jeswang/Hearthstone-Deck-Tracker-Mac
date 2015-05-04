//
//  CardsViewController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/5/3.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardsViewController.h"
#import "CardModel.h"
#import "CardCollectionViewItem.h"

@interface CardsViewController ()
@property (nonatomic, weak) IBOutlet NSCollectionView *cardCollectionView;
@property (nonatomic, strong) NSMutableArray* cards;
@end

@implementation CardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    NSMutableArray *cards = [[CardModel actualCards] mutableCopy];
    NSMutableArray *cardsModels = [NSMutableArray new];
    for (CardModel *card in cards) {
        CardCollectionViewItem *item = [CardCollectionViewItem new];
        [item setCardImageWithId:card.cardId];
        [cardsModels addObject:item];
    }
    [self.cardCollectionView setContent:cardsModels];
}

@end
