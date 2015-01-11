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

@interface CardListViewController()

@property(nonatomic, weak) IBOutlet NSTableView* tableView;
@property(nonatomic, strong) NSMutableArray *cards;

@end

@implementation CardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cards = [NSMutableArray new];
    
    //NSArray *cards = [NSArray new];
    self.cards = [NSMutableArray arrayWithArray:[CardModel actualCards]];
    CardModel *card = [self.cards objectAtIndex:0];
    card.count = 2;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView setBackgroundColor:[NSColor colorWithCalibratedWhite:86.0/255.0 alpha:1]];
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [appDelegate.updateList addObject:self];
}

- (void)updateWithCards:(NSArray *)cards {
    [self.cards removeAllObjects];
    [self.cards addObjectsFromArray:cards];
    
    [self.tableView reloadData];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.cards count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    CardModel *card = [self.cards objectAtIndex:row];
    CardCellView *cell = [CardCellView initWithCard:card];
    
    return cell;
}

@end
