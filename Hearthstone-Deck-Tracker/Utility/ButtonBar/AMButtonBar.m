//
//	AMButtonBar.m
//	ButtonBarTest
//
//	Created by Andreas on 09.02.07.
//	Copyright 2007 Andreas Mayer. All rights reserved.
//
//  2010-02-18  Andreas Mayer
//  - use NSGradient instead of CTGradient for 10.5 and above


#import "AMButtonBar.h"
#import "AMButtonBarItem.h"
#import "AMButtonBarCell.h"
#import "AMButtonBarSeparatorCell.h"
#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
#import "NSGradient_AMButtonBar.h"
#else
#import "CTGradient.h"
#import "CTGradient_AMButtonBar.h"
#endif

float const AM_START_GAP_WIDTH = 8.0;
float const AM_BUTTON_GAP_WIDTH = 2.0;
float const AM_BUTTON_HEIGHT = 20.0;

NSString *const AMButtonBarSelectionDidChangeNotification = @"AMButtonBarSelectionDidChangeNotification";

@interface NSShadow (AMButtonBar)
+ (NSShadow *)amButtonBarSelectedItemShadow;
@end

@implementation NSShadow (AMButtonBar)

+ (NSShadow *)amButtonBarSelectedItemShadow
{
	NSShadow *result = [[[NSShadow alloc] init] autorelease];
	[result setShadowOffset:NSMakeSize(0.0, 1.0)];
	[result setShadowBlurRadius:1.0];
	[result setShadowColor:[NSColor colorWithCalibratedWhite:0 alpha:0.7]];
	return result;
}

@end


@interface AMButtonBar (Private)
- (void)am_commonInit;
- (void)setItems:(NSMutableArray *)newItems;
- (BOOL)needsLayout;
- (void)setNeedsLayout:(BOOL)value;
- (BOOL)delegateRespondsToSelectionDidChange;
- (void)setDelegateRespondsToSelectionDidChange:(BOOL)value;
- (void)setButtonCell:(AMButtonBarCell *)value;
- (void)setSeparatorCell:(AMButtonBarSeparatorCell *)value;
- (void)configureButtonCell;
- (AMButtonBarItem *)itemAtPoint:(NSPoint)point;
- (NSRect)frameForItemAtIndex:(int)index;
- (void)drawItemAtIndex:(int)index;
- (void)drawItem:(AMButtonBarItem *)item;
- (void)layoutItems;
- (void)removeTrackingRects;
- (void)calculateFrameSizeForItem:(AMButtonBarItem *)item;
- (void)prepareCellWithItem:(AMButtonBarItem *)item;
- (NSCell *)cellForItem:(AMButtonBarItem *)item;
- (void)handleMouseDownForPointInWindow:(NSValue *)value;
- (void)didClickItem:(AMButtonBarItem *)item;
- (void)sendActionForItem:(AMButtonBarItem *)item;
@end


@implementation AMButtonBar

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self am_commonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	[self am_commonInit];
	delegate = [decoder decodeObjectForKey:@"AMBBDelegate"];
	delegateRespondsToSelectionDidChange = [decoder decodeBoolForKey:@"AMBBDelegateRespondsToSelectionDidChange"];
#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
	[self setBackgroundGradient:[decoder decodeObjectForKey:@"AMBBBackgroundNSGradient"]];
#else
	[self setBackgroundGradient:[decoder decodeObjectForKey:@"AMBBBackgroundGradient"]];
#endif
	[self setBaselineSeparatorColor:[decoder decodeObjectForKey:@"AMBBBaselineSeparatorColor"]];
	showsBaselineSeparator = [decoder decodeBoolForKey:@"AMBBShowsBaselineSeparator"];
	allowsMultipleSelection = [decoder decodeBoolForKey:@"AMBBAllowsMultipleSelection"];
	[self setItems:[decoder decodeObjectForKey:@"AMBBItems"]];
	[self setButtonCell:[decoder decodeObjectForKey:@"AMBBButtonCell"]];
	[self setNeedsLayout:YES];
	return self;
}

- (void)am_commonInit
{
	[self setItems:[[[NSMutableArray alloc] init] autorelease]];
#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
	[self setBackgroundGradient:[NSGradient grayButtonBarGradient]];
#else
	[self setBackgroundGradient:[CTGradient grayButtonBarGradient]];
#endif
		//[self setBackgroundGradient:[CTGradient blueButtonBarGradient]];
	[self setBaselineSeparatorColor:[NSColor grayColor]];
	[self setShowsBaselineSeparator:YES];
	[self setButtonCell:[[[AMButtonBarCell alloc] init] autorelease]];
	[self setSeparatorCell:[[[AMButtonBarSeparatorCell alloc] init] autorelease]];
	[self configureButtonCell];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeConditionalObject:delegate forKey:@"AMBBDelegate"];
	[coder encodeBool:delegateRespondsToSelectionDidChange forKey:@"AMBBDelegateRespondsToSelectionDidChange"];
#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
	[coder encodeObject:backgroundGradient forKey:@"AMBBBackgroundNSGradient"];
#else
	[coder encodeObject:backgroundGradient forKey:@"AMBBBackgroundGradient"];
#endif
	[coder encodeObject:baselineSeparatorColor forKey:@"AMBBBaselineSeparatorColor"];
	[coder encodeBool:showsBaselineSeparator forKey:@"AMBBShowsBaselineSeparator"];
	[coder encodeBool:allowsMultipleSelection forKey:@"AMBBAllowsMultipleSelection"];
	[coder encodeObject:items forKey:@"AMBBItems"];
	[coder encodeObject:buttonCell forKey:@"AMBBButtonCell"];
}


- (void)dealloc
{
	[backgroundGradient release];
	[baselineSeparatorColor release];
	[items release];
	[buttonCell release];
	[separatorCell release];
	[super dealloc];
}


//====================================================================
#pragma mark 		accessors
//====================================================================

- (id)delegate
{
	return delegate;
}

- (void)setDelegate:(id)value
{
	// do not retain delegate
	delegate = value;
	[self setDelegateRespondsToSelectionDidChange:[delegate respondsToSelector:@selector(buttonBarSelectionDidChange:)]];
}

- (BOOL)allowsMultipleSelection
{
	return allowsMultipleSelection;
}

- (void)setAllowsMultipleSelection:(BOOL)value
{
	if (allowsMultipleSelection != value) {
		allowsMultipleSelection = value;
	}
}


#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
- (NSGradient *)backgroundGradient
{
	return backgroundGradient;
}

- (void)setBackgroundGradient:(NSGradient *)value
{
	if (backgroundGradient != value) {
		id old = backgroundGradient;
		backgroundGradient = [value retain];
		[old release];
	}
}
#else
- (CTGradient *)backgroundGradient
{
	return backgroundGradient;
}

- (void)setBackgroundGradient:(CTGradient *)value
{
	if (backgroundGradient != value) {
		id old = backgroundGradient;
		backgroundGradient = [value retain];
		[old release];
	}
}
#endif

- (NSColor *)baselineSeparatorColor
{
	return baselineSeparatorColor;
}

- (void)setBaselineSeparatorColor:(NSColor *)value
{
	if (baselineSeparatorColor != value) {
		id old = baselineSeparatorColor;
		baselineSeparatorColor = [value retain];
		[old release];
	}
}

- (BOOL)showsBaselineSeparator
{
	return showsBaselineSeparator;
}

- (void)setShowsBaselineSeparator:(BOOL)value
{
	if (showsBaselineSeparator != value) {
		showsBaselineSeparator = value;
	}
}

- (NSArray *)items
{
	return [[items retain] autorelease];
}

- (void)setItems:(NSMutableArray *)newItems
{
	if (items != newItems) {
		id old = items;
		items = [newItems retain];
		[old release];
	}
}

- (NSString *)selectedItemIdentifier
{
	NSString *result = nil;
	NSEnumerator *enumerator = [[self items] objectEnumerator];
	AMButtonBarItem *item;
	while (item = [enumerator nextObject]) {
		if ([item state] == NSOnState) {
			result = [item itemIdentifier];
			break;
		}
	}
	return result;
}

- (NSArray *)selectedItemIdentifiers
{
	NSMutableArray *result = [NSMutableArray array];
	NSEnumerator *enumerator = [[self items] objectEnumerator];
	AMButtonBarItem *item;
	while (item = [enumerator nextObject]) {
		if ([item state] == NSOnState) {
			[result addObject:[item itemIdentifier]];
		}
	}
	return result;
}

- (AMButtonBarCell *)buttonCell
{
	return buttonCell;
}

- (void)setButtonCell:(AMButtonBarCell *)value
{
	if (buttonCell != value) {
		id old = buttonCell;
		buttonCell = [value retain];
		[old release];
	}
}

- (AMButtonBarSeparatorCell *)separatorCell
{
	return separatorCell;
}

- (void)setSeparatorCell:(AMButtonBarSeparatorCell *)value
{
	if (separatorCell != value) {
		id old = separatorCell;
		separatorCell = [value retain];
		[old release];
	}
}

- (BOOL)delegateRespondsToSelectionDidChange
{
	return delegateRespondsToSelectionDidChange;
}

- (void)setDelegateRespondsToSelectionDidChange:(BOOL)value
{
	delegateRespondsToSelectionDidChange = value;
}

- (BOOL)needsLayout
{
	return needsLayout;
}

- (void)setNeedsLayout:(BOOL)value
{
	if (needsLayout != value) {
		needsLayout = value;
	}
}


//====================================================================
#pragma mark 		public methods
//====================================================================

- (AMButtonBarItem *)itemAtIndex:(int)index
{
	return [(NSMutableArray *)[self items] objectAtIndex:index];
}

- (void)insertItem:(AMButtonBarItem *)item atIndex:(int)index
{
	[(NSMutableArray *)[self items] insertObject:item atIndex:index];
	[self setNeedsLayout:YES];
}

- (void)removeItem:(AMButtonBarItem *)item
{
	if ([item trackingRectTag] != 0) {
//		NSLog(@"removeTrackingRect:");
		[self removeTrackingRect:[item trackingRectTag]];
	}
	[(NSMutableArray *)[self items] removeObject:item];
	[self setNeedsLayout:YES];
}

- (void)removeItemAtIndex:(int)index
{
	[self removeItem:[(NSMutableArray *)[self items] objectAtIndex:index]];
}

- (void)removeAllItems
{
	[(NSMutableArray *)[self items] removeAllObjects];
	[self setNeedsLayout:YES];
}

- (void)selectItemWithIdentifier:(NSString *)identifier
{
	NSEnumerator *enumerator = [[self items] objectEnumerator];
	AMButtonBarItem *item;
	while (item = [enumerator nextObject]) {
		if ([[item itemIdentifier] isEqualToString:identifier]) {
			[self didClickItem:item];
			break;
		}
	}
}

- (void)selectItemsWithIdentifiers:(NSArray *)identifierList
{
	if ([self allowsMultipleSelection] || ([identifierList count] < 2)) {
		NSEnumerator *enumerator = [[self items] objectEnumerator];
		AMButtonBarItem *item;
		while (item = [enumerator nextObject]) {
			if ([identifierList containsObject:[item itemIdentifier]]) {
				[self didClickItem:item];
			}
		}
	}
}


//====================================================================
#pragma mark 		private methods
//====================================================================

- (void)configureButtonCell
{
	AMButtonBarCell *cell = [self buttonCell];
	[cell setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]]];
	cell = [self separatorCell];
	[cell setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]]];
}

- (AMButtonBarItem *)itemAtPoint:(NSPoint)point;
{
	AMButtonBarItem *result = nil;
	NSEnumerator *enumerator = [[self items] objectEnumerator];
	AMButtonBarItem *item;
	while (item = [enumerator nextObject]) {
		if (![item isSeparatorItem]) {
			NSRect frame = [item frame];
			if (NSPointInRect(point, frame)) {
				result = item;
				break;
			}
			if (frame.origin.x > point.x) {
				break;
			}
		}
	}
	return result;
}

- (NSRect)frameForItemAtIndex:(int)index
{
	return [[[self items] objectAtIndex:index] frame];
}

- (void)drawItemAtIndex:(int)index
{
	[self drawItem:[self itemAtIndex:index]];
}

- (void)drawItem:(AMButtonBarItem *)item
{
	[self prepareCellWithItem:item];
//	NSRect frame = [item frame];
//	NSLog(@"frame: %f %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
	[[self cellForItem:item] drawWithFrame:[item frame] inView:self];
}

- (void)layoutItems
{
	[self setNeedsLayout:NO];
	NSPoint origin;
	origin.y = (([self frame].size.height-1 - AM_BUTTON_HEIGHT) / 2.0);
	if (![self isFlipped]) {
		origin.y += 1;
	}
	origin.x = AM_START_GAP_WIDTH;
	NSEnumerator *enumerator = [[self items] objectEnumerator];
	id item;
	while (item = [enumerator nextObject]) {
		[self calculateFrameSizeForItem:item];
		[item setFrameOrigin:origin];
		origin.x += [item frame].size.width;
		origin.x += AM_BUTTON_GAP_WIDTH;
		if ([item trackingRectTag] != 0) {
//			NSLog(@"removeTrackingRect:");
			[self removeTrackingRect:[item trackingRectTag]];
		}
//		NSLog(@"setTrackingRect:");
		if (![item isSeparatorItem]) {
			[item setTrackingRectTag:[self addTrackingRect:[item frame] owner:self userData:item assumeInside:NO]];  //... should check for mouse inside
		}
	}
}

- (void)removeTrackingRects
{
	NSEnumerator *enumerator = [[self items] objectEnumerator];
	id item;
	while (item = [enumerator nextObject]) {
		if ([item trackingRectTag] != 0) {
			[self removeTrackingRect:[item trackingRectTag]];
		}
	}
}

- (void)calculateFrameSizeForItem:(AMButtonBarItem *)item
{
	[self prepareCellWithItem:item];
	NSRect frame = [item frame];
	frame.size.height = AM_BUTTON_HEIGHT;
	frame.size.width = [(AMButtonBarCell *)[self cellForItem:item] widthForFrame:frame];
	[item setFrame:frame];
}

- (void)prepareCellWithItem:(AMButtonBarItem *)item
{
	// make a working copy
	if (![item isSeparatorItem]) {
		[[self buttonCell] setTitle:[item title]];
		[[self buttonCell] setMouseOver:[item isMouseOver]];
		[[self buttonCell] setState:[item state]];
//		[[self buttonCell] setHighlighted:([item state] == NSOnState)];
		[[self buttonCell] setHighlighted:[item isActive]];
		[[self buttonCell] setEnabled:[item isEnabled]];
	}
}

- (NSCell *)cellForItem:(AMButtonBarItem *)item
{
	NSCell *result;
	if ([item isSeparatorItem]) {
		result = [self separatorCell];
	} else {
		result = [self buttonCell];
	}
	return result;
}

- (void)mouseOverItem:(AMButtonBarItem *)mouseOverItem
{
	BOOL mouseOver;
	BOOL needsRedraw;
	NSEnumerator *enumerator = [[self items] objectEnumerator];
	AMButtonBarItem *item;
	while (item = [enumerator nextObject]) {
		mouseOver = (item == mouseOverItem);
		needsRedraw = ([item isMouseOver] != mouseOver);
		[item setMouseOver:mouseOver];
		if (needsRedraw) {
			[self setNeedsDisplayInRect:[item frame]];
		}
	}
}

- (void)handleMouseDownForPointInWindow:(NSValue *)value
{
	BOOL done = NO;
	NSEvent *theEvent = [NSApp currentEvent];
	NSPoint point = [value pointValue];
	point = [self convertPoint:point fromView:nil];
	AMButtonBarItem *item = [self itemAtPoint:point];
	if (item && [item isEnabled]) {
		int oldState = [item state];
		[item setState:NSOnState];
		[item setActive:YES];
		[self prepareCellWithItem:item];
		[self setNeedsDisplayInRect:[item frame]];
		[self displayIfNeeded];
		if ([[self cellForItem:item] trackMouse:theEvent inRect:[item frame] ofView:self untilMouseUp:NO]) {
			// clicked
			//[item setState:((oldState == NSOnState) ? NSOffState : NSOnState)];
			done = YES;
//		} else {
//			[item setState:oldState];
		}
		[item setState:oldState];
		[item setActive:NO];
		[self setNeedsDisplayInRect:[item frame]];
	}
	if (done) {
		[self didClickItem:item];
	} else {
		point = [[self window] mouseLocationOutsideOfEventStream];
		[self performSelector:@selector(handleMouseDownForPointInWindow:) withObject:[NSValue valueWithPoint:point] afterDelay:0.1];
	}
}

- (void)didClickItem:(AMButtonBarItem *)theItem
{
	BOOL didChangeSelection = NO;
	if (![self allowsMultipleSelection]) {
		if ([theItem state] == NSOffState) {
			NSEnumerator *enumerator = [[self items] objectEnumerator];
			AMButtonBarItem *item;
			while (item = [enumerator nextObject]) {
				[item setState:((item == theItem) ? NSOnState : NSOffState)];
			}
			[self setNeedsDisplay:YES];
			didChangeSelection = YES;
		}		
	} else {
		[theItem setState:(([theItem state] == NSOnState) ? NSOffState : NSOnState)];
		[self setNeedsDisplayInRect:[theItem frame]];
		didChangeSelection = YES;
	}
	if (didChangeSelection) {
		NSNotification *notification = [NSNotification notificationWithName:AMButtonBarSelectionDidChangeNotification object:self userInfo:[NSDictionary dictionaryWithObject:[self selectedItemIdentifiers] forKey:@"selectedItems"]];
		[self sendActionForItem:theItem];
		if ([self delegateRespondsToSelectionDidChange]) {
			[delegate buttonBarSelectionDidChange:notification];
		}
		[[NSNotificationCenter defaultCenter] postNotification:notification];
	}
}

- (void)sendActionForItem:(AMButtonBarItem *)item
{
	if ([item target]) {
		[NSApp sendAction:[item action] to:[item target] from:item];
	}
}


//====================================================================
#pragma mark 		NSResponder methods
//====================================================================

- (void)mouseEntered:(NSEvent *)theEvent
{
	//NSLog(@"mouseEntered:");
	AMButtonBarItem *item = [theEvent userData];
	if ([item isEnabled]) {
		[item setMouseOver:YES];
		[self setNeedsDisplayInRect:[item frame]];
	}
}

- (void)mouseExited:(NSEvent *)theEvent
{
	//NSLog(@"mouseExited:");
	AMButtonBarItem *item = [theEvent userData];
	[item setMouseOver:NO];
	[self setNeedsDisplayInRect:[item frame]];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	[self handleMouseDownForPointInWindow:[NSValue valueWithPoint:[theEvent locationInWindow]]];
}

- (void)mouseUp:(NSEvent *)theEvent
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self]; // dangerous?
}


//====================================================================
#pragma mark 		NSView methods
//====================================================================

- (void)drawRect:(NSRect)rect
{
	NSRect gradientBounds = [self bounds];
	NSRect baselineRect = gradientBounds;
	if ([self showsBaselineSeparator]) {
		gradientBounds.size.height -= 1;
		baselineRect.size.height = 1;
		if ([self isFlipped]) {
			baselineRect.origin.y = gradientBounds.size.height;
		} else {
			baselineRect.origin.y = 0;
			gradientBounds.origin.y += 1;
		}
	}
	float angle = 90;
	if ([self isFlipped]) {
		angle = -90;
	}
#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
	[[self backgroundGradient] drawInRect:gradientBounds angle:angle];
#else
	[[self backgroundGradient] fillRect:gradientBounds angle:angle];
#endif
	if ([self showsBaselineSeparator]) {
		[[self baselineSeparatorColor] set];
		NSFrameRect(baselineRect);
	}
	if ([self needsLayout]) {
		[self layoutItems];
	}
	NSEnumerator *enumerator = [[self items] objectEnumerator];
	id item;
	while (item = [enumerator nextObject]) {
		if (NSIntersectsRect([item frame], rect)) {
			[self drawItem:item];
		}
	}
}

- (void)viewDidMoveToWindow
{
	if ([self window]) {
		[self setNeedsLayout:YES];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameDidChange:) name:NSWindowDidResizeNotification object:[self window]];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameDidChange:) name:NSViewFrameDidChangeNotification object:self];
	} else {
		[self removeTrackingRects];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewFrameDidChangeNotification object:self];
	}
}

- (BOOL)postsFrameChangedNotifications
{
	return YES;
}

- (BOOL)isFlipped
{
	return YES;
}


//====================================================================
#pragma mark 		NSView notification methods
//====================================================================

- (void)frameDidChange:(NSNotification *)aNotification
{
	//NSLog(@"frameDidChange:");
	[self setNeedsLayout:YES]; 
}


@end
