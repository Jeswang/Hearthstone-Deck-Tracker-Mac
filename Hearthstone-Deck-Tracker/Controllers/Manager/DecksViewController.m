//
//  DecksViewController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/5/3.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "DecksViewController.h"
#import "PXSourceList.h"
#import "DeckModel.h"

static NSString * const draggingType = @"SourceListExampleDraggingType";

@interface DecksViewController () {
}

@property (weak, nonatomic) IBOutlet PXSourceList *sourceList;
@property (assign) IBOutlet NSButton *removeButton;

@property (strong, nonatomic) NSMutableArray *modelObjects;
@property (strong, nonatomic) NSMutableArray *sourceListItems;

@property (nonatomic, strong) DeckModel *selectedDeck;

@end

@implementation DecksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.sourceList registerForDraggedTypes:@[draggingType]];

    self.sourceListItems = [[NSMutableArray alloc] init];
    
    // Store all of the model objects in an array because each source list item only holds a weak reference to them.
    self.modelObjects = [DeckModel decks];
    
    NSImage *deckImage = [NSImage imageNamed:@"album"];
    [deckImage setTemplate:YES];
    
    PXSourceListItem *albumsItem = [PXSourceListItem itemWithTitle:@"DECKS" identifier:nil];
    
    [self.sourceListItems addObject:albumsItem];
    for (DeckModel* model in self.modelObjects) {
        [albumsItem addChildItem:[PXSourceListItem itemWithRepresentedObject:model icon:deckImage]];
    }
    [self.sourceList reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addCard:)
                                                 name:@"AddCard"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeCard:)
                                                 name:@"RemoveCard"
                                               object:nil];
}

- (void)addCard:(NSNotification *)notification {
    if (self.selectedDeck) {
        NSString *cardId = [notification object];
        [self.selectedDeck addCard:cardId];
        [NC postNotificationName:@"UpdateDeck" object:nil];
    }
}

- (void)removeCard:(NSNotification *)notification {
    if (self.selectedDeck) {
        NSString *cardId = [notification object];
        [self.selectedDeck removeCard:cardId];
        [NC postNotificationName:@"UpdateDeck" object:nil];
    }
}

- (PXSourceListItem *)albumsItem
{
    return self.sourceListItems[0];
}

#pragma mark - Actions

- (IBAction)addButtonAction:(id)sender
{
    NSImage *deckImage = [NSImage imageNamed:@"album"];
    [deckImage setTemplate:YES];
    
    DeckModel *deck = [DeckModel deckWithDeckName:@"New Deck"];
    
    [self.modelObjects addObject:deck];
    
    PXSourceListItem *newItem = [PXSourceListItem itemWithRepresentedObject:deck icon:deckImage];
    [self.albumsItem addChildItem:newItem];
    
    NSUInteger childIndex = [[self.albumsItem children] indexOfObject:newItem];
    
    [self.sourceList insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:childIndex]
                                 inParent:self.albumsItem
                            withAnimation:NSTableViewAnimationEffectNone];
    
    if (childIndex == 0) {
        [self.sourceList reloadData];
    }
    //[self.sourceList reloadData];
    [self.sourceList editColumn:0 row:[self.sourceList rowForItem:newItem] withEvent:nil select:YES];
}

- (IBAction)removeButtonAction:(id)sender
{
    [DeckModel deleteDeck:self.selectedDeck];
    
    PXSourceListItem *selectedItem = [self.sourceList itemAtRow:self.sourceList.selectedRow];
    PXSourceListItem *parentItem = self.albumsItem;
    
    [self.sourceList removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:[parentItem.children indexOfObject:selectedItem]]
                                 inParent:parentItem
                            withAnimation:NSTableViewAnimationSlideUp];
    
    [self.modelObjects removeObject:selectedItem.representedObject];
    
    // Only 'album' items can be deleted.
    [parentItem removeChildItem:selectedItem];
}

#pragma mark - PXSourceList Data Source

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
    if (!item)
        return self.sourceListItems.count;
    
    return [[item children] count];
}

- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
    if (!item)
        return self.sourceListItems[index];
    
    return [[item children] objectAtIndex:index];
}

- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
    return [item hasChildren];
}

#pragma mark - PXSourceList Delegate

- (BOOL)sourceList:(PXSourceList *)aSourceList isGroupAlwaysExpanded:(id)group
{
    return YES;
}

- (NSView *)sourceList:(PXSourceList *)aSourceList viewForItem:(id)item
{
    PXSourceListTableCellView *cellView = nil;
    if ([aSourceList levelForItem:item] == 0)
        cellView = [aSourceList makeViewWithIdentifier:@"HeaderCell" owner:nil];
    else
        cellView = [aSourceList makeViewWithIdentifier:@"MainCell" owner:nil];
    
    PXSourceListItem *sourceListItem = item;
    DeckModel *deck = sourceListItem.representedObject;
    
    // Only allow us to edit the user created photo collection titles.
    BOOL isTitleEditable = [deck isKindOfClass:[DeckModel class]];
    cellView.textField.editable = isTitleEditable;
    cellView.textField.selectable = isTitleEditable;
    
    cellView.textField.stringValue = sourceListItem.title ? sourceListItem.title : [sourceListItem.representedObject name];
    cellView.imageView.image = [item icon];
    cellView.badgeView.hidden = deck.totalCount == 0;
    cellView.badgeView.badgeValue = deck.totalCount;

    @weakify(deck)
    [cellView.textField.rac_textSignal subscribeNext:^(id x) {
        @strongify(deck)
        [REALM beginWriteTransaction];
        deck.name = (NSString *)x;
        [REALM commitWriteTransaction];
    }];
    
    @weakify(cellView)
    [RACObserve(deck, totalCount) subscribeNext:^(NSNumber *x) {
        @strongify(cellView)
        NSInteger count = [x integerValue];
        cellView.badgeView.hidden = count == 0;
        cellView.badgeView.badgeValue = count;
        [cellView setNeedsLayout:YES];
        [cellView.badgeView setNeedsDisplay:YES];
    }];
    
    return cellView;
}

- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
    PXSourceListItem *selectedItem = [self.sourceList itemAtRow:self.sourceList.selectedRow];
    BOOL removeButtonEnabled = NO;
    if (selectedItem) {
        removeButtonEnabled = [[self.albumsItem children] containsObject:selectedItem];
        self.selectedDeck = [self.modelObjects objectAtIndex:self.sourceList.selectedRow-1];
        
        [NC postNotificationName:@"SelectDeck" object:self.selectedDeck];
    }
    else {
        self.selectedDeck = nil;
        [NC postNotificationName:@"SelectDeck" object:nil];
    }
    
    self.removeButton.enabled = removeButtonEnabled;
}

#pragma mark - Drag and Drop

- (BOOL)sourceList:(PXSourceList*)aSourceList writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard
{
    // Only allow user-created items (not those in "Library" to be moved around).
    for (PXSourceListItem *item in items) {
        DeckModel *collection = item.representedObject;
        if (![collection isKindOfClass:[DeckModel class]])
            return NO;
    }
    
    // We're dragging from and to the 'Albums' group.
    PXSourceListItem *parentItem = self.albumsItem;
    
    // For simplicity in this example, put the dragged indexes on the pasteboard. Since we use the representedObject
    // on SourceListItem, we cannot reliably archive it directly.
    NSMutableIndexSet *draggedChildIndexes = [NSMutableIndexSet indexSet];
    for (PXSourceListItem *item in items)
        [draggedChildIndexes addIndex:[[parentItem children] indexOfObject:item]];
    
    [pboard declareTypes:@[draggingType] owner:self];
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:draggedChildIndexes] forType:draggingType];
    
    return YES;
}

- (NSDragOperation)sourceList:(PXSourceList*)sourceList validateDrop:(id < NSDraggingInfo >)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
    PXSourceListItem *albumsItem = self.albumsItem;

    if (![item isEqual:albumsItem])
        return NSDragOperationNone;
    
    return NSDragOperationMove;
}

- (BOOL)sourceList:(PXSourceList*)aSourceList acceptDrop:(id < NSDraggingInfo >)info item:(id)item childIndex:(NSInteger)index
{
    NSPasteboard *draggingPasteboard = info.draggingPasteboard;
    NSMutableIndexSet *draggedChildIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:[draggingPasteboard dataForType:draggingType]];
    
    PXSourceListItem *parentItem = self.albumsItem;
    NSMutableArray *draggedItems = [NSMutableArray array];
    [draggedChildIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [draggedItems addObject:[[parentItem children] objectAtIndex:idx]];
    }];
    
    // An index of -1 means it's been dropped on the group header itself, so insert at the end of the group.
    if (index == -1)
        index = parentItem.children.count;
    
    // Perform the Source List and model updates.
    [aSourceList beginUpdates];
    [aSourceList removeItemsAtIndexes:draggedChildIndexes
                             inParent:parentItem
                        withAnimation:NSTableViewAnimationEffectNone];
    [parentItem removeChildItems:draggedItems];
    
    // We have to calculate the new child index which we have to perform the drop at, since we've just removed items from the parent item which
    // may have come before the drop index.
    NSUInteger adjustedDropIndex = index - [draggedChildIndexes countOfIndexesInRange:NSMakeRange(0, index)];
    
    // The insertion indexes are now simply from the adjusted drop index.
    NSIndexSet *insertionIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(adjustedDropIndex, draggedChildIndexes.count)];
    [parentItem insertChildItems:draggedItems atIndexes:insertionIndexes];
    
    [aSourceList insertItemsAtIndexes:insertionIndexes
                             inParent:parentItem
                        withAnimation:NSTableViewAnimationEffectNone];
    [aSourceList endUpdates];
    
    return YES;
}

@end
