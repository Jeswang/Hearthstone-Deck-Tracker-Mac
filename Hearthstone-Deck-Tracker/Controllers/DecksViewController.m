//
//  DecksViewController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/5/3.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "DecksViewController.h"

@interface DecksViewController () {
    IBOutlet NSOutlineView *deckOutlineView;
}

@property (strong) NSMutableArray *decks; // used to keep track of dragged nodes

@end

@implementation DecksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
