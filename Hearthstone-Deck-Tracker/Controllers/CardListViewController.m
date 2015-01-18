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
#import "CardPreviewController.h"
#import "Configuration.h"

@interface CardListViewController()

@property(nonatomic, weak) IBOutlet NSTableView* tableView;
@property(nonatomic, strong) NSMutableArray *cards;
@property(nonatomic, strong) NSMutableArray *showingCards;

@property(nonatomic, strong) NSWindowController *previewWindowController;
@property(nonatomic, strong) NSString *currentPreviewCardId;
@end

@implementation CardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cards = [NSMutableArray new];
    
    self.cards = [[CardModel actualCards] mutableCopy];
    self.showingCards = [[CardModel actualCards] mutableCopy];
    
    //self.cards = [NSMutableArray new];
    //self.showingCards = [NSMutableArray new];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView setBackgroundColor:[NSColor colorWithCalibratedWhite:86.0/255.0 alpha:1]];
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    [appDelegate.updateList addObject:self];
    [[[Hearthstone defaultInstance] updateList] addObject:self];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadCountry:)
                                                 name:kCountryLanguageChanged
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadCards:)
                                                 name:kFadeCardsChanged
                                               object:nil];
}

- (void)reloadCountry:(NSNotification *)notification {
    NSMutableArray *tmp = [NSMutableArray new];
    NSString *country = [Configuration instance].countryLanguage;
    for (CardModel *card in self.cards) {
        CardModel *newCard = [CardModel cardById:card.cardId ofCountry:country];
        newCard.count = card.count;
        [tmp addObject:newCard];
    }
    [CardModel sortCards:tmp];
    self.cards = tmp;
    [self resetCards];
}

- (void)reloadCards:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (void)viewDidDisappear {
    [super viewDidDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.showingCards count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    CardModel *card = [self.showingCards objectAtIndex:row];
    CardCellView *cell = [CardCellView initWithCard:card];
    cell.delegate = self;
    return cell;
}

- (void)hoverCell:(NSTableCellView *)cell mouseInside:(BOOL)mouseInside{
    if (mouseInside) {
        CardCellView *cardCell = (CardCellView *)cell;
        [self showPreviewWindowBeside:cardCell];
    }
    else {
        [self hidePreviewWindow:(CardCellView *)cell];
    }
}

- (void)hidePreviewWindow:(CardCellView *)cell {
    if (cell.card.cardId == self.currentPreviewCardId) {
        [self.previewWindowController.window close];
        self.currentPreviewCardId = nil;
    }
}

- (void)showPreviewWindowBeside:(CardCellView *)cell {
    if (_previewWindowController == nil) {
        NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
        self.previewWindowController = [sb instantiateControllerWithIdentifier:@"CardPreviewWindowController"];
        [self.previewWindowController.window setOpaque:NO];
        [self.previewWindowController.window setBackgroundColor:[NSColor clearColor]];
        [self.previewWindowController.window setLevel:NSScreenSaverWindowLevel];
    }
    
    CardPreviewController *contentController =  (CardPreviewController *)self.previewWindowController.contentViewController;
    [contentController loadCardByCardId:cell.card.cardId];
    
    self.currentPreviewCardId = cell.card.cardId;
    
    [self.previewWindowController showWindow:self.previewWindowController.window];
    
    NSPoint point = [self calPreivewWindowPointBesideCell:cell];
    
    [self.previewWindowController.window setFrameTopLeftPoint:point];
}

- (NSPoint)calPreivewWindowPointBesideCell:(CardCellView *)cell {
    NSInteger row = [self.tableView rowForView:cell];
    NSInteger column = [self.tableView columnForView:cell];
    NSRect rect = [self.tableView frameOfCellAtColumn:column row:row];
    
    float offset = rect.origin.y - self.tableView.enclosingScrollView.documentVisibleRect.origin.y;
    
    NSRect windowRect = self.view.window.frame;
    //NSSize screenSize = self.view.window.screen.frame.size;
    
    float x,y;
    if (windowRect.origin.x < 200) {
        x = windowRect.origin.x + windowRect.size.width;
    }
    else {
        x = windowRect.origin.x-200;
    }
    
    y = windowRect.origin.y+windowRect.size.height - offset - 30;
    if (y < 278) {
        y = 278;
    }
    
    return NSMakePoint(x, y);
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
            if (card.count <= 1) {
                card.count = 0;
                
                if (![Configuration instance].fadeCards) {
                    [self.showingCards removeObject:card];
                }
                
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

- (void)restoreCard:(NSString *)cardId {
    for (CardModel *card in self.showingCards) {
        if (card.cardId == cardId) {
                card.count = card.count + 1;
                [self.tableView reloadData];
                return;
        }
    }
    
    for (CardModel *card in self.cards) {
        if (card.cardId == cardId) {
            CardModel *newCard = [card deepCopy];
            newCard.count = 1;
            [self.showingCards addObject:newCard];
            [self.tableView reloadData];
            return;
        }
    }
}


@end
