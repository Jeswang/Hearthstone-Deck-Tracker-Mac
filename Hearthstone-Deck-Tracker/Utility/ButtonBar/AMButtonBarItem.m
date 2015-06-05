//
//  AMButtonBarItem.m
//  ButtonBarTest
//
//  Created by Andreas on 09.02.07.
//  Copyright 2007 Andreas Mayer. All rights reserved.
//

#import "AMButtonBarItem.h"


@implementation AMButtonBarItem

- (id)initWithIdentifier:(NSString *)theIdentifier;
{
	self = [super init];
	if (self != nil) {
		[self setItemIdentifier:theIdentifier];
		[self setFrame:NSZeroRect];
		[self setEnabled:YES];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	itemIdentifier = [[decoder decodeObjectForKey:@"AMBBIItemIdentifier"] retain];
	toolTip = [[decoder decodeObjectForKey:@"AMBBIToolTip"] retain];
	title = [[decoder decodeObjectForKey:@"AMBBITitle"] retain];
	alternateTitle = [[decoder decodeObjectForKey:@"AMBBIAlternateTitle"] retain];
	target = [decoder decodeObjectForKey:@"AMBBITarget"];
	action = NSSelectorFromString([decoder decodeObjectForKey:@"AMBBISelector"]);
	enabled = [decoder decodeBoolForKey:@"AMBBISelector"];
	active = [decoder decodeBoolForKey:@"AMBBIActive"];
	separatorItem = [decoder decodeBoolForKey:@"AMBBISeparatorItem"];
	overflowItem = [decoder decodeBoolForKey:@"AMBBIOverflowItem"];
	state = [decoder decodeIntForKey:@"AMBBIState"];
	tag = [decoder decodeIntForKey:@"AMBBITag"];
	frame = [decoder decodeRectForKey:@"AMBBIFrame"];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:itemIdentifier forKey:@"AMBBIItemIdentifier"];
	[coder encodeObject:toolTip forKey:@"AMBBIToolTip"];
	[coder encodeObject:title forKey:@"AMBBITitle"];
	[coder encodeObject:alternateTitle forKey:@"AMBBIAlternateTitle"];
	[coder encodeConditionalObject:target forKey:@"AMBBITarget"];
	[coder encodeObject:NSStringFromSelector(action) forKey:@"AMBBISelector"];
	[coder encodeBool:enabled forKey:@"AMBBISelector"];
	[coder encodeBool:active forKey:@"AMBBIActive"];
	[coder encodeBool:separatorItem forKey:@"AMBBISeparatorItem"];
	[coder encodeBool:overflowItem forKey:@"AMBBIOverflowItem"];
	[coder encodeInt:state forKey:@"AMBBIState"];
	[coder encodeInt:tag forKey:@"AMBBITag"];
	[coder encodeRect:frame forKey:@"AMBBIFrame"];
}


- (void)dealloc
{
	[overflowMenu release];
	[itemIdentifier release];
	[toolTip release];
	[title release];
	[alternateTitle release];
	[super dealloc];
}


- (id)target
{
	return target;
}

- (void)setTarget:(id)value
{
	if (target != value) {
		id old = target;
		target = [value retain];
		[old release];
	}
}

- (SEL)action
{
	return action;
}

- (void)setAction:(SEL)value
{
	if (action != value) {
		action = value;
	}
}

- (BOOL)isEnabled
{
	return enabled;
}

- (void)setEnabled:(BOOL)value
{
	if ((enabled != value) && (![self isSeparatorItem])) {
		enabled = value;
	}
}

- (BOOL)isMouseOver
{
	return mouseOver;
}

- (void)setMouseOver:(BOOL)value
{
	if ((mouseOver != value) && (![self isSeparatorItem])) {
		mouseOver = value;
	}
}

- (BOOL)isActive
{
	return active;
}

- (void)setActive:(BOOL)value
{
	if ((active != value) && (![self isSeparatorItem])) {
		active = value;
	}
}

- (BOOL)isSeparatorItem
{
	return separatorItem;
}

- (void)setSeparatorItem:(BOOL)value
{
	if (separatorItem != value) {
		separatorItem = value;
	}
}

- (BOOL)isOverflowItem
{
	return overflowItem;
}

- (void)setOverflowItem:(BOOL)value
{
	if (overflowItem != value) {
		overflowItem = value;
	}
}

- (int)state
{
	return state;
}

- (void)setState:(int)value
{
	if (state != value) {
		state = value;
	}
}

- (NSString *)itemIdentifier
{
	return itemIdentifier;
}

- (void)setItemIdentifier:(NSString *)value
{
	if (itemIdentifier != value) {
		id old = itemIdentifier;
		itemIdentifier = [value retain];
		[old release];
	}
}

- (int)tag
{
	return tag;
}

- (void)setTag:(int)value
{
	if (tag != value) {
		tag = value;
	}
}

- (NSString *)toolTip
{
	return toolTip;
}

- (void)setToolTip:(NSString *)value
{
	if (toolTip != value) {
		id old = toolTip;
		toolTip = [value retain];
		[old release];
	}
}

- (NSString *)title
{
	return title;
}

- (void)setTitle:(NSString *)value
{
	if (title != value) {
		id old = title;
		title = [value retain];
		[old release];
	}
}

- (NSString *)alternateTitle
{
	return alternateTitle;
}

- (void)setAlternateTitle:(NSString *)value
{
	if (alternateTitle != value) {
		id old = alternateTitle;
		alternateTitle = [value retain];
		[old release];
	}
}

- (NSMenu *)overflowMenu
{
	return overflowMenu;
}

- (void)setOverflowMenu:(NSMenu *)value
{
	if (overflowMenu != value) {
		id old = overflowMenu;
		overflowMenu = [value retain];
		[old release];
	}
}

- (NSTrackingRectTag)trackingRectTag
{
	return trackingRectTag;
}

- (void)setTrackingRectTag:(NSTrackingRectTag)value
{
	trackingRectTag = value;
}

- (NSRect)frame
{
	return frame;
}

- (void)setFrame:(NSRect)value
{
	frame = value;
}

- (void)setFrameOrigin:(NSPoint)origin
{
	frame.origin = origin;
}


@end
