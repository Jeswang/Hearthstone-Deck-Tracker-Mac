//
//  AMButtonBarItem.h
//  ButtonBarTest
//
//  Created by Andreas on 09.02.07.
//  Copyright 2007 Andreas Mayer. All rights reserved.
//

//  tool tips and special items like separators and overflow menus are not yet supported


#import <Cocoa/Cocoa.h>


@interface AMButtonBarItem : NSObject <NSCoding> {
	id target;
	SEL action;
	BOOL enabled;
	BOOL mouseOver;
	BOOL active;
	BOOL separatorItem;
	BOOL overflowItem;
	int state;
	NSString *itemIdentifier;
	int tag;
	NSString *toolTip;
	NSString *title;
	NSString *alternateTitle;
	NSMenu *overflowMenu;
	NSRect frame;
	NSTrackingRectTag trackingRectTag;
}

- (id)initWithIdentifier:(NSString *)identifier;

- (id)target;
- (void)setTarget:(id)value;

- (SEL)action;
- (void)setAction:(SEL)value;

- (BOOL)isEnabled;
- (void)setEnabled:(BOOL)value;

- (BOOL)isMouseOver;
- (void)setMouseOver:(BOOL)value;

- (BOOL)isActive;
- (void)setActive:(BOOL)value;

- (BOOL)isSeparatorItem;
- (void)setSeparatorItem:(BOOL)value;

- (BOOL)isOverflowItem;
- (void)setOverflowItem:(BOOL)value;

- (int)state;
- (void)setState:(int)value;

- (NSString *)itemIdentifier;
- (void)setItemIdentifier:(NSString *)value;

- (int)tag;
- (void)setTag:(int)value;

- (NSString *)toolTip;
- (void)setToolTip:(NSString *)value;

- (NSString *)title;
- (void)setTitle:(NSString *)value;

- (NSString *)alternateTitle;
- (void)setAlternateTitle:(NSString *)value;

- (NSMenu *)overflowMenu;
- (void)setOverflowMenu:(NSMenu *)value;

- (NSTrackingRectTag)trackingRectTag;
- (void)setTrackingRectTag:(NSTrackingRectTag)value;

- (NSRect)frame;
- (void)setFrame:(NSRect)value;

- (void)setFrameOrigin:(NSPoint)origin;


@end
