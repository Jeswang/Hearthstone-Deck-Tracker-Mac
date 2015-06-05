//
//  AMButtonBarCell.h
//  AMButtonBar
//
//  Created by Andreas on Sat 2007-02-10
//  Copyright (c) 2004 Andreas Mayer. All rights reserved.

//	different representations:
// - off
//		(no background, text, text shadow)
// - off + mouse over
//		(light background without shadow, text, text shadow)
// - on
//		(medium background, top shadow, bottom light (shadow), text, text shadow)
// - on + mouse over
//		(light background, top shadow, bottom light (shadow), text, text shadow)
// - on/off + mouse down
//		(dark background, top shadow, bottom light (shadow), text, text shadow)


#import <AppKit/AppKit.h>
#import "NSBezierPath_AMShading.h"


@interface AMButtonBarCell : NSButtonCell {
	BOOL am_mouseOver;
	BOOL am_mouseDown;
	// private: basic layout and geometry data
	NSBezierPath *am_controlPath;
	NSBezierPath *am_innerControlPath;
	NSSize am_lastFrameSize;
	NSRect am_textRect;
	SEL am_getBackgroundSelector;
}

+ (NSColor *)offControlColor;
+ (NSColor *)offTextColor;
+ (NSShadow *)offTextShadow;

+ (NSColor *)offMouseOverControlColor;
+ (NSColor *)offMouseOverTextColor;
+ (NSShadow *)offMouseOverTextShadow;

+ (NSColor *)onControlColor;
+ (NSShadow *)onControlUpperShadow;
+ (NSShadow *)onControlLowerShadow;
+ (NSColor *)onTextColor;
+ (NSShadow *)onTextShadow;

+ (NSColor *)onMouseOverControlColor;
+ (NSShadow *)onMouseOverControlUpperShadow;
+ (NSShadow *)onMouseOverControlLowerShadow;
+ (NSColor *)onMouseOverTextColor;
+ (NSShadow *)onMouseOverTextShadow;

+ (NSColor *)mouseDownControlColor;
+ (NSShadow *)mouseDownControlUpperShadow;
+ (NSShadow *)mouseDownControlLowerShadow;
+ (NSColor *)mouseDownTextColor;
+ (NSShadow *)mouseDownTextShadow;

- (BOOL)mouseOver;
- (void)setMouseOver:(BOOL)newMouseOver;

- (BOOL)mouseDown;
- (void)setMouseDown:(BOOL)newMouseDown;

- (float)widthForFrame:(NSRect)frameRect;


@end
