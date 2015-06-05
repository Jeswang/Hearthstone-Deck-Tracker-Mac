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

#import "AMButtonBar.h"
#import "AMButtonBarItem.h"
#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
#import "NSGradient_AMButtonBar.h"
#else
#import "CTGradient.h"
#import "CTGradient_AMButtonBar.h"
#endif

@interface CardsViewController ()
@property (nonatomic, weak) IBOutlet NSCollectionView *cardCollectionView;
@property (nonatomic, weak) IBOutlet AMButtonBar *buttonBar;
@property (nonatomic, strong) NSMutableArray* cards;
@end

@implementation CardsViewController

- (void)awakeFromNib
{
    AMButtonBarItem *item =[[AMButtonBarItem alloc] initWithIdentifier:@"title"];
    [item setTitle:@"Title"];
    [self.buttonBar insertItem:item atIndex:0];
    item = [[AMButtonBarItem alloc] initWithIdentifier:@"artist"];
    [item setTitle:@"Artist"];
    [self.buttonBar insertItem:item atIndex:1];
    item = [[AMButtonBarItem alloc] initWithIdentifier:@"album"];
    [item setTitle:@"Album"];
    [self.buttonBar insertItem:item atIndex:2];

    [self.buttonBar setNeedsDisplay:YES];
    [self.buttonBar setDelegate:self];
}


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
