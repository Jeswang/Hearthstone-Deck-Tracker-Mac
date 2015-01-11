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

@interface CardListViewController()

@property(nonatomic, weak) IBOutlet NSTableView* tableView;
@property(nonatomic, strong) NSMutableArray *cards;

@end

@implementation CardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cards = [NSMutableArray new];
    
    //NSArray *cards = [NSArray new];
    NSArray *cards = [CardModel actualCards];

    for(CardModel *card in cards) {
        [self.cards addObject:card];
    }

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView setBackgroundColor:[NSColor colorWithCalibratedWhite:86.0/255.0 alpha:1]];
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
