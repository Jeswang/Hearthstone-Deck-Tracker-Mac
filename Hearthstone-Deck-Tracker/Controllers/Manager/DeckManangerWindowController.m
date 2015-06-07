//
//  DeckManangerController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/11.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "DeckManangerWindowController.h"
#import "CardListViewController.h"
#import "DecksViewController.h"
#import "CardsViewController.h"
#import "Masonry.h"

@interface DeckManangerWindowController ()
@property (nonatomic, weak) IBOutlet NSView *deckView;
@property (nonatomic, weak) IBOutlet NSView *detailView;
@property (nonatomic, weak) IBOutlet NSView *cardsView;

@property (nonatomic, strong) CardListViewController *detailViewController;
@property (nonatomic, strong) DecksViewController *deckViewController;
@property (nonatomic, strong) CardsViewController *cardsViewController;
@end

@implementation DeckManangerWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.deckViewController = [[DecksViewController alloc] init];
    
    self.detailViewController = [[CardListViewController alloc] init];
    self.detailViewController.isManager = true;
    
    self.cardsViewController = [[CardsViewController alloc] init];
    
    [self insertController:self.deckViewController toSubview:self.deckView];
    [self insertController:self.detailViewController toSubview:self.detailView];
    [self insertController:self.cardsViewController toSubview:self.cardsView];
    
    [self.cardsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(700);
    }];
    
    
}

- (void)insertController:(NSViewController *)controller toSubview:(NSView*)subview {
    [subview addSubview:[controller view]];
    
    [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(subview);
    }];
}

@end
