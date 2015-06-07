//
//  ViewController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/9.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardListViewController.h"
#import "CardModel.h"
#import "DeckModel.h"
#import "CardCellView.h"
#import "AppDelegate.h"
#import "RLMObject+Copying.h"
#import "Hearthstone.h"
#import "CardPreviewController.h"
#import "Configuration.h"

@interface CardListViewController()

@property(nonatomic, weak) IBOutlet NSTableView* tableView;

@property(nonatomic, strong) NSMutableArray *showingCards;
@property(nonatomic, strong) DeckModel *currentDeck;

@property(nonatomic, strong) CardPreviewController *previewWindowController;
@property(nonatomic, strong) NSString *currentPreviewCardId;
@end

@implementation CardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showingCards = [NSMutableArray new];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView setBackgroundColor:[NSColor colorWithCalibratedWhite:86.0/255.0 alpha:1]];
    
    if (!self.isManager) {
        [[APP updateList] addObject:self];
        [[[Hearthstone defaultInstance] updateList] addObject:self];
    }
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [NC addObserver:self
           selector:@selector(reloadCountry:)
               name:kCountryLanguageChanged
             object:nil];
    
    [NC addObserver:self
           selector:@selector(reloadCards:)
               name:kFadeCardsChanged
             object:nil];
    
    if (self.isManager) {
        [NC addObserver:self selector:@selector(updateDeck:) name:@"UpdateDeck" object:nil];
    }

    [NC addObserver:self selector:@selector(selectDeck:) name:@"SelectDeck" object:nil];

}


- (void)selectDeck:(NSNotification *)notification {
    self.currentDeck = notification.object;
    [self resetCards];
}

- (void)updateDeck:(NSNotification *)notification {
    [self resetCards];
}

- (void)viewDidDisappear {
    [super viewDidDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)reloadCountry:(NSNotification *)notification {
    [self resetCards];
}

- (void)reloadCards:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (IBAction)columnChangeSelected:(id)sender
{
    NSInteger selectedRow = [self.tableView selectedRow];
    
    if (selectedRow != -1) {
        NSLog(@"Do something with selectedRow! %ld", selectedRow);
        CardModel *card = [self.showingCards objectAtIndex:selectedRow];
        [self.tableView deselectRow:selectedRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveCard" object:card.cardId];
    }
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
    if (self.isManager) {
        return;
    }
    
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
        self.previewWindowController = [[CardPreviewController alloc] initWithWindowNibName:@"CardPreviewWindow"];
        [self.previewWindowController.window setOpaque:NO];
        [self.previewWindowController.window setBackgroundColor:[NSColor clearColor]];
        [self.previewWindowController.window setLevel:NSScreenSaverWindowLevel];
    }
    
    [self.previewWindowController loadCardByCardId:cell.card.cardId];
    
    self.currentPreviewCardId = cell.card.cardId;
    
    [self.previewWindowController showWindow:self.previewWindowController.window];
    
    NSPoint point = [self calPreviewWindowPointBesideCell:cell];

    NSWindow *window = self.previewWindowController.window;
    NSRect newFrame = [window frame];
    
    newFrame.origin = point;
    newFrame.origin.y -= newFrame.size.height;
    //[self.previewWindowController.window setFrameTopLeftPoint:point];
    [self.previewWindowController.window setFrame:newFrame display:YES animate:YES];
}

- (NSPoint)calPreviewWindowPointBesideCell:(CardCellView *)cell {
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

- (void)updateWithDeck:(DeckModel *)deck {
    self.currentDeck = deck;
    [self resetCards];
    
    [self.tableView reloadData];
}

- (void)resetCards {
    [self.showingCards removeAllObjects];
    if (!self.currentDeck) {
        return;
    }
    for (CardItem *card in self.currentDeck.cards) {
        CardModel *newCard = [CardModel cardById:card.cardId ofCountry:COUNTRY];
        newCard.count = card.count;
        [self.showingCards addObject:newCard];
    }
    [CardModel sortCards:self.showingCards];
    
    [self.tableView reloadData];
}


- (void)removeCard:(NSString *)cardId {
    for (CardModel *card in self.showingCards) {
        if (card.cardId == cardId) {
            if (card.count <= 1) {
                card.count = 0;
                
                if (!FADE_CARDS || self.isManager) {
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

    CardModel *newCard = [CardModel cardById:cardId ofCountry:COUNTRY];
    newCard.count = 1;
    
    [self.showingCards addObject:newCard];
    
    [CardModel sortCards:self.showingCards];
    
    [self.tableView reloadData];

}


@end
