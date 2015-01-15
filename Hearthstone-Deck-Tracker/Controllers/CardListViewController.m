//
//  ViewController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/9.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardListViewController.h"
#import "CardModel.h"
#import "CardCellView.h"
#import "AppDelegate.h"
#import "RLMObject+Copying.h"
#import "Hearthstone.h"

@interface CardListViewController()

@property(nonatomic, weak) IBOutlet NSTableView* tableView;
@property(nonatomic, strong) NSMutableArray *cards;
@property(nonatomic, strong) NSMutableArray *showingCards;

@end

@implementation CardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cards = [NSMutableArray new];
    
    //NSArray *cards = [NSArray new];
    self.cards = [NSMutableArray new];
    self.showingCards = [NSMutableArray new];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView setBackgroundColor:[NSColor colorWithCalibratedWhite:86.0/255.0 alpha:1]];
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    [appDelegate.updateList addObject:self];
    [[[Hearthstone defaultInstance] updateList] addObject:self];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.showingCards count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    CardModel *card = [self.showingCards objectAtIndex:row];
    CardCellView *cell = [CardCellView initWithCard:card];
    
    return cell;
}

- (void)updateWithCards:(NSArray *)cards {
    [self.cards removeAllObjects];
    [self.cards addObjectsFromArray:cards];
    
    [self resetCards];
    [self.tableView reloadData];
}

- (void)resetCards {
    [self.showingCards removeAllObjects];
    for (id card in self.cards) {
        [self.showingCards addObject:[card deepCopy]];
    }
    [self.tableView reloadData];
}

- (void)removeCard:(NSString *)cardId {
    for (CardModel *card in self.showingCards) {
        if (card.cardId == cardId) {
            if (card.count == 1) {
                [self.showingCards removeObject:card];
                [self.tableView reloadData];
                return;
            }
            else {
                card.count = card.count - 1;
                [self.tableView reloadData];
                return;
            }
        }
    }
}

@end
