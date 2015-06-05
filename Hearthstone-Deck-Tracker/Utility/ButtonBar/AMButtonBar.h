//
//  AMButtonBar.h
//  ButtonBarTest
//
//  Created by Andreas on 09.02.07.
//  Copyright 2007 Andreas Mayer. All rights reserved.
//
//  2010-02-18  Andreas Mayer
//  - use NSGradient instead of CTGradient for 10.5 and above


#import <Cocoa/Cocoa.h>

#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@class NSGradient;
#else
@class CTGradient;
#endif
@class AMButtonBarItem;
@class AMButtonBarCell;
@class AMButtonBarSeparatorCell;


extern NSString *const AMButtonBarSelectionDidChangeNotification;


@interface NSObject (AMButtonBarDelegate)
- (void)buttonBarSelectionDidChange:(NSNotification *)aNotification;
@end


@interface AMButtonBar : NSView {
	id delegate;
	BOOL delegateRespondsToSelectionDidChange;
#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
	NSGradient *backgroundGradient;
#else
	CTGradient *backgroundGradient;
#endif
	NSColor *baselineSeparatorColor;
	BOOL showsBaselineSeparator;
	BOOL allowsMultipleSelection;
	NSMutableArray *items;
	AMButtonBarCell *buttonCell;
	AMButtonBarSeparatorCell *separatorCell;
	BOOL needsLayout;
}


- (id)initWithFrame:(NSRect)frame;

- (AMButtonBarCell *)buttonCell;
- (AMButtonBarSeparatorCell *)separatorCell;

- (NSArray *)items;

- (NSString *)selectedItemIdentifier;
- (NSArray *)selectedItemIdentifiers;

- (AMButtonBarItem *)itemAtIndex:(int)index;

- (void)insertItem:(AMButtonBarItem *)item atIndex:(int)index;

- (void)removeItem:(AMButtonBarItem *)item;
- (void)removeItemAtIndex:(int)index;
- (void)removeAllItems;

- (void)selectItemWithIdentifier:(NSString *)identifier;
- (void)selectItemsWithIdentifiers:(NSArray *)identifierList;

- (id)delegate;
- (void)setDelegate:(id)value;

- (BOOL)allowsMultipleSelection;
- (void)setAllowsMultipleSelection:(BOOL)value;

#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
- (NSGradient *)backgroundGradient;
- (void)setBackgroundGradient:(NSGradient *)value;
#else
- (CTGradient *)backgroundGradient;
- (void)setBackgroundGradient:(CTGradient *)value;
#endif

- (NSColor *)baselineSeparatorColor;
- (void)setBaselineSeparatorColor:(NSColor *)value;

- (BOOL)showsBaselineSeparator;
- (void)setShowsBaselineSeparator:(BOOL)value;



@end
