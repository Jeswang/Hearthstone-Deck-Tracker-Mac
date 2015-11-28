//
//  AMButtonBarCell.m
//  AMButtonBar
//
//  Created by Andreas on 2007-02-10
//  Copyright (c) 2004 Andreas Mayer. All rights reserved.

// assumes a flipped control

//  2010-02-12  Andreas Mayer
//  - replaced use of NSFont's deprecated -widthOfString with appropriate NSString method
//  2010-02-18  Andreas Mayer
//  - removed deprecated invocations of -setCachesBezierPath:


#import "AMButtonBarCell.h"
#import "NSBezierPath_AMAdditons.h"
#import "NSColor_AMAdditions.h"
#import "NSFont_AMFixes.h"
#import "NSShadow_AMAdditions.h"

static float am_backgroundInset = 1.5;
static float am_textGap = 1.5;
static float am_bezierPathFlatness = 0.2;


@interface AMButtonBarCell (Private)
- (NSSize)lastFrameSize;
- (void)setLastFrameSize:(NSSize)newLastFrameSize;
- (float)calculateTextInsetForRadius:(float)radius font:(NSFont *)font;
- (void)finishInit;
@end


@implementation AMButtonBarCell

+ (NSColor *)offControlColor
{
	static NSColor *offControlColor = nil;
	if (!offControlColor) {
		offControlColor = [[NSColor clearColor] retain];
	}
	return offControlColor;
}

+ (NSColor *)offTextColor
{
	static NSColor *offTextColor = nil;
	if (!offTextColor) {
		offTextColor = [[NSColor colorWithCalibratedWhite:0 alpha:1] retain];
	}
	return offTextColor;
}

+ (NSShadow *)offTextShadow
{
	static NSShadow *offTextShadow = nil;
	if (!offTextShadow) {
		NSColor *color = [NSColor colorWithCalibratedWhite:1 alpha:1];
		offTextShadow = [[NSShadow shadowWithColor:color blurRadius:1 offset:NSMakeSize(0, -1)] retain];
	}
	return offTextShadow;
}


+ (NSColor *)offMouseOverControlColor
{
	static NSColor *offMouseOverControlColor = nil;
	if (!offMouseOverControlColor) {
		offMouseOverControlColor = [[NSColor colorWithCalibratedWhite:.5 alpha:.5] retain];
	}
	return offMouseOverControlColor;
}

+ (NSColor *)offMouseOverTextColor
{
	static NSColor *offMouseOverTextColor = nil;
	if (!offMouseOverTextColor) {
		offMouseOverTextColor = [[NSColor colorWithCalibratedWhite:1 alpha:1] retain];
	}
	return offMouseOverTextColor;
}

+ (NSShadow *)offMouseOverTextShadow
{
	static NSShadow *offMouseOverTextShadow = nil;
//	if (!offMouseOverTextShadow) {
//		NSColor *color = [NSColor colorWithCalibratedWhite:.2 alpha:1];
//		offMouseOverTextShadow = [[NSShadow shadowWithColor:color blurRadius:1 offset:NSMakeSize(0, 1)] retain];
//	}
	return offMouseOverTextShadow;
}


+ (NSColor *)onControlColor
{
	static NSColor *onControlColor = nil;
	if (!onControlColor) {
		onControlColor = [[NSColor colorWithCalibratedWhite:.6 alpha:1] retain];
	}
	return onControlColor;
}

+ (NSShadow *)onControlUpperShadow
{
	static NSShadow *onControlUpperShadow = nil;
	if (!onControlUpperShadow) {
		NSColor *color = [NSColor colorWithCalibratedWhite:.0 alpha:.5];
		onControlUpperShadow = [[NSShadow shadowWithColor:color blurRadius:1 offset:NSMakeSize(0,  1)] retain];
	}
	return onControlUpperShadow;
}

+ (NSShadow *)onControlLowerShadow
{
	static NSShadow *onControlLowerShadow = nil;
	if (!onControlLowerShadow) {
		NSColor *color = [NSColor colorWithCalibratedWhite:1 alpha:.5];
		onControlLowerShadow = [[NSShadow shadowWithColor:color blurRadius:1 offset:NSMakeSize(0, -1)] retain];
	}
	return onControlLowerShadow;
}

+ (NSColor *)onTextColor
{
	static NSColor *onTextColor = nil;
	if (!onTextColor) {
		onTextColor = [[NSColor colorWithCalibratedWhite:1 alpha:1] retain];
	}
	return onTextColor;
}

+ (NSShadow *)onTextShadow
{
	static NSShadow *onTextShadow = nil;
	if (!onTextShadow) {
		NSColor *color = [NSColor colorWithCalibratedWhite:.6 alpha:1];
		onTextShadow = [[NSShadow shadowWithColor:color blurRadius:1 offset:NSMakeSize(0, 1)] retain];
	}
	return onTextShadow;
}


+ (NSColor *)onMouseOverControlColor
{
	static NSColor *onMouseOverControlColor = nil;
	if (!onMouseOverControlColor) {
		onMouseOverControlColor = [[NSColor colorWithCalibratedWhite:.68 alpha:1] retain];
	}
	return onMouseOverControlColor;
}

+ (NSShadow *)onMouseOverControlUpperShadow
{
	static NSShadow *onMouseOverControlUpperShadow = nil;
	if (!onMouseOverControlUpperShadow) {
		NSColor *color = [NSColor colorWithCalibratedWhite:0 alpha:.5];
		onMouseOverControlUpperShadow = [[NSShadow shadowWithColor:color blurRadius:1 offset:NSMakeSize(0, 1)] retain];
	}
	return onMouseOverControlUpperShadow;
}

+ (NSShadow *)onMouseOverControlLowerShadow
{
	static NSShadow *onMouseOverControlLowerShadow = nil;
	if (!onMouseOverControlLowerShadow) {
		NSColor *color = [NSColor colorWithCalibratedWhite:1 alpha:.5];
		onMouseOverControlLowerShadow = [[NSShadow shadowWithColor:color blurRadius:1 offset:NSMakeSize(0, -1)] retain];
	}
	return onMouseOverControlLowerShadow;
}

+ (NSColor *)onMouseOverTextColor
{
	static NSColor *onMouseOverTextColor = nil;
	if (!onMouseOverTextColor) {
		onMouseOverTextColor = [[NSColor colorWithCalibratedWhite:1 alpha:1] retain];
	}
	return onMouseOverTextColor;
}

+ (NSShadow *)onMouseOverTextShadow
{
	static NSShadow *onMouseOverTextShadow = nil;
//	if (!onMouseOverTextShadow) {
//		NSColor *color = [NSColor colorWithCalibratedWhite:.7 alpha:1];
//		onMouseOverTextShadow = [[NSShadow shadowWithColor:color blurRadius:1 offset:NSMakeSize(0, 1)] retain];
//	}
	return onMouseOverTextShadow;
}


+ (NSColor *)mouseDownControlColor
{
	static NSColor *mouseDownControlColor = nil;
	if (!mouseDownControlColor) {
		mouseDownControlColor = [[NSColor colorWithCalibratedWhite:.5 alpha:1] retain];
	}
	return mouseDownControlColor;
}

+ (NSShadow *)mouseDownControlUpperShadow
{
	static NSShadow *mouseDownControlUpperShadow = nil;
	if (!mouseDownControlUpperShadow) {
		NSColor *color = [NSColor colorWithCalibratedWhite:0 alpha:.4];
		mouseDownControlUpperShadow = [[NSShadow shadowWithColor:color blurRadius:1 offset:NSMakeSize(0, 1)] retain];
	}
	return mouseDownControlUpperShadow;
}

+ (NSShadow *)mouseDownControlLowerShadow
{
	static NSShadow *mouseDownControlLowerShadow = nil;
	if (!mouseDownControlLowerShadow) {
		NSColor *color = [NSColor colorWithCalibratedWhite:.9 alpha:.5];
		mouseDownControlLowerShadow = [[NSShadow shadowWithColor:color blurRadius:1 offset:NSMakeSize(0, -1)] retain];
	}
	return mouseDownControlLowerShadow;
}

+ (NSColor *)mouseDownTextColor
{
	static NSColor *mouseDownTextColor = nil;
	if (!mouseDownTextColor) {
		mouseDownTextColor = [[NSColor colorWithCalibratedWhite:1 alpha:1] retain];
	}
	return mouseDownTextColor;
}

+ (NSShadow *)mouseDownTextShadow
{
	static NSShadow *mouseDownTextShadow = nil;
	if (!mouseDownTextShadow) {
		NSColor *color = [NSColor colorWithCalibratedWhite:.4 alpha:1];
		mouseDownTextShadow = [[NSShadow shadowWithColor:color blurRadius:1 offset:NSMakeSize(0, 1)] retain];
	}
	return mouseDownTextShadow;
}



- (id)initTextCell:(NSString *)aString
{
	if (self = [super initTextCell:aString]) {
		[self finishInit];
	}
	return self;
}

- (void)finishInit
{
	[super setBezelStyle:NSShadowlessSquareBezelStyle];
	[self setAlignment:NSCenterTextAlignment];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	[self setAlignment:NSCenterTextAlignment];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[super encodeWithCoder:coder];
}

- (void)dealloc
{
	[am_controlPath release];
	[am_innerControlPath release];
	[super dealloc];
}


- (NSBezierPath *)backgroundPath
{
    return am_controlPath;
}

- (void)setControlPath:(NSBezierPath *)newControlPath
{
    id old = nil;

    if (newControlPath != am_controlPath) {
        old = am_controlPath;
        am_controlPath = [newControlPath retain];
        [old release];
    }
}

- (NSBezierPath *)innerControlPath
{
    return am_innerControlPath;
}

- (void)setInnerControlPath:(NSBezierPath *)newInnerControlPath
{
    id old = nil;

    if (newInnerControlPath != am_innerControlPath) {
        old = am_innerControlPath;
        am_innerControlPath = [newInnerControlPath retain];
        [old release];
    }
}

- (NSSize)lastFrameSize
{
	return am_lastFrameSize;
}

- (void)setLastFrameSize:(NSSize)newLastFrameSize
{
	am_lastFrameSize = newLastFrameSize;
}

- (BOOL)mouseOver
{
    return am_mouseOver;
}

- (void)setMouseOver:(BOOL)newMouseOver
{
    am_mouseOver = newMouseOver;
}

- (BOOL)mouseDown
{
	return am_mouseDown;
}

- (void)setMouseDown:(BOOL)value
{
	am_mouseDown = value;
}


- (void)calculateLayoutForFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	// bezier path for plate background
	[self setLastFrameSize:cellFrame.size];
	NSRect innerRect = NSInsetRect(cellFrame, am_backgroundInset, am_backgroundInset);
	// text rect
	am_textRect = innerRect;
	NSFont *font = [self font];
	NSDictionary *stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
	NSAttributedString *string = [[[NSAttributedString alloc] initWithString:[self title] attributes:stringAttributes] autorelease];
	NSSize size = [string size];
	float radius = (am_lastFrameSize.height/2.0)-am_backgroundInset;
	// calculate minimum text inset
	float textInset;
	float h = [font ascender]/2.0;
	textInset = ceilf(radius-sqrt(radius*radius - h*h));
	am_textRect = NSInsetRect(am_textRect, textInset+am_textGap, 0);
	am_textRect.size.height = size.height;
	float capHeight = [font fixed_capHeight];
	float ascender = [font ascender];
	float yOrigin = innerRect.origin.y;
	float offset = ((innerRect.size.height-am_textRect.size.height) / 2.0);
	offset += (ascender-capHeight)-((am_textRect.size.height-capHeight) / 2.0);
	yOrigin += floorf(offset);
	am_textRect.origin.y = yOrigin;

	// bezier path for button background
	innerRect.origin.x = 0;
	innerRect.origin.y = 0;
		
	id returnValue;
	returnValue = [NSBezierPath bezierPathWithPlateInRect:innerRect];
	[self setControlPath:returnValue];

	// bezier path for pressed button (with gap for shadows)
	innerRect.size.height--;
	innerRect.origin.y++;

	returnValue = [NSBezierPath bezierPathWithPlateInRect:innerRect];
	[self setInnerControlPath:returnValue];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	if ((am_lastFrameSize.width != cellFrame.size.width) || (am_lastFrameSize.height != cellFrame.size.height)) {
		[self calculateLayoutForFrame:cellFrame inView:controlView];
	}
	[self drawInteriorWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSBezierPath *path;
	NSColor *controlColor;
	NSShadow *upperShadow = nil;
	NSShadow *lowerShadow = nil;
	NSColor *textColor;
	NSShadow *textShadow;
	NSAffineTransform *transformation = [NSAffineTransform transform];
	[transformation translateXBy:cellFrame.origin.x+am_backgroundInset yBy:cellFrame.origin.y+am_backgroundInset];
	if (![self isEnabled]) { // disabled
		if ([self state] == NSOnState) { // on
			controlColor = [AMButtonBarCell onControlColor];
			upperShadow = [AMButtonBarCell onControlUpperShadow];
			lowerShadow = [AMButtonBarCell onControlLowerShadow];
			path = [[am_innerControlPath copy] autorelease];
			textColor = [AMButtonBarCell onTextColor];
			textShadow = [AMButtonBarCell onTextShadow];
		} else { // off
			controlColor = [AMButtonBarCell offControlColor];
			path = [[am_controlPath copy] autorelease];
			textColor = [AMButtonBarCell offTextColor];
			textShadow = [AMButtonBarCell offTextShadow];
		}
		controlColor = [controlColor disabledColor];
		textColor = [textColor disabledColor];
	} else { // enabled
		if ([self isHighlighted]) { // mouse down
			controlColor = [AMButtonBarCell mouseDownControlColor];
			upperShadow = [AMButtonBarCell mouseDownControlUpperShadow];
			lowerShadow = [AMButtonBarCell mouseDownControlLowerShadow];
			path = [[am_innerControlPath copy] autorelease];
			textColor = [AMButtonBarCell mouseDownTextColor];
			textShadow = [AMButtonBarCell mouseDownTextShadow];
		} else if ([self state] == NSOnState) { // on
			if (am_mouseOver) {
				controlColor = [AMButtonBarCell onMouseOverControlColor];
				upperShadow = [AMButtonBarCell onMouseOverControlUpperShadow];
				lowerShadow = [AMButtonBarCell onMouseOverControlLowerShadow];
				path = [[am_innerControlPath copy] autorelease];
				textColor = [AMButtonBarCell onMouseOverTextColor];
				textShadow = [AMButtonBarCell onMouseOverTextShadow];
			} else {
				controlColor = [AMButtonBarCell onControlColor];
				upperShadow = [AMButtonBarCell onControlUpperShadow];
				lowerShadow = [AMButtonBarCell onControlLowerShadow];
				path = [[am_innerControlPath copy] autorelease];
				textColor = [AMButtonBarCell onTextColor];
				textShadow = [AMButtonBarCell onTextShadow];
			}
		} else { // off
			if (am_mouseOver) {
				controlColor = [AMButtonBarCell offMouseOverControlColor];
				path = [[am_controlPath copy] autorelease];
				textColor = [AMButtonBarCell offMouseOverTextColor];
				textShadow = [AMButtonBarCell offMouseOverTextShadow];
			} else  {
				controlColor = [AMButtonBarCell offControlColor];
				path = [[am_controlPath copy] autorelease];
				textColor = [AMButtonBarCell offTextColor];
				textShadow = [AMButtonBarCell offTextShadow];
			}
		}
	}

	[NSGraphicsContext saveGraphicsState];
	[path transformUsingAffineTransform:transformation];
	[path setLineWidth:0.0];
	[path setFlatness:am_bezierPathFlatness];
	if (upperShadow) { // draw two halves with shadow
		[controlColor set];
		[NSGraphicsContext saveGraphicsState];
		// adjust clipping rectangle
		NSRect halfFrame = cellFrame;
		halfFrame.size.height =  floorf(halfFrame.size.height/2);
		[NSBezierPath clipRect:halfFrame];
		[upperShadow set];
		[path fill];
		[NSGraphicsContext restoreGraphicsState];
		[NSGraphicsContext saveGraphicsState];
		halfFrame.origin.y = cellFrame.origin.y+halfFrame.size.height;
		[NSBezierPath clipRect:halfFrame];
		[lowerShadow set];
		[path fill];
		[NSGraphicsContext restoreGraphicsState];
		// draw middle part without shadow
		halfFrame.origin.y = cellFrame.origin.y+floorf(cellFrame.size.height/2)-1;
		halfFrame.size.height = 2;
		[NSBezierPath clipRect:halfFrame];
		[path fill];
	} else { // draw one path only
		[controlColor set];
		[path fill];
	}
	[NSGraphicsContext restoreGraphicsState];

	[NSGraphicsContext saveGraphicsState];
	[textShadow set];
	// draw button title
	NSDictionary *stringAttributes;
	NSFont *font;
	NSMutableParagraphStyle *parapraphStyle = [[[NSMutableParagraphStyle alloc] init] autorelease];
	[parapraphStyle setAlignment:[self alignment]];
	font = [self font];
	stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, textColor, NSForegroundColorAttributeName, parapraphStyle, NSParagraphStyleAttributeName, nil];
	[[self title] drawInRect:am_textRect withAttributes:stringAttributes];
	[NSGraphicsContext restoreGraphicsState];
}

- (float)widthForFrame:(NSRect)frameRect
{
	float result;
	NSFont *font = [self font];
//	result = ceilf([font widthOfString:[self title]]);
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
	result = ceilf([[self title] sizeWithAttributes:attributes].width);
	float radius = (frameRect.size.height/2.0)-am_backgroundInset;

	float textInset;
	float h = [font ascender]/2.0;
	textInset = ceilf(radius-sqrt(radius*radius - h*h)+(radius*0.25));

	result += 2.0*(textInset+am_backgroundInset+am_textGap);
	if ([self menu] != nil) {
		float arrowWidth = [NSFont systemFontSizeForControlSize:[self controlSize]]*0.6;
		result += (radius*0.5)+arrowWidth;
	}
	return result;
}

- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)untilMouseUp
{
	
	BOOL result = NO;
	//NSLog(@"trackMouse:inRect:ofView:untilMouseUp:");
	NSDate *endDate;
	NSPoint currentPoint = [theEvent locationInWindow];
	BOOL done = NO;
	BOOL trackContinously = [self startTrackingAt:currentPoint inView:controlView];
	// catch next mouse-dragged or mouse-up event until timeout
	BOOL mouseIsUp = NO;
	NSEvent *event;
	while (!done) { // loop ...
		NSPoint lastPoint = currentPoint;
		endDate = [NSDate distantFuture];
		event = [NSApp nextEventMatchingMask:(NSLeftMouseUpMask|NSLeftMouseDraggedMask) untilDate:endDate inMode:NSEventTrackingRunLoopMode dequeue:YES];
		if (event) { // mouse event
			currentPoint = [event locationInWindow];
			if (trackContinously) { // send continueTracking.../stopTracking...
				if (![self continueTracking:lastPoint at:currentPoint inView:controlView]) {
					done = YES;
					[self stopTracking:lastPoint at:currentPoint inView:controlView mouseIsUp:mouseIsUp];
				}
				if ([self isContinuous]) {
					[NSApp sendAction:[self action] to:[self target] from:controlView];
				}
			}
			mouseIsUp = ([event type] == NSLeftMouseUp);
			[self setMouseDown:mouseIsUp];
			done = done || mouseIsUp;
			if (untilMouseUp) {
				result = mouseIsUp;
			} else {
				// check, if the mouse left our cell rect
				result = NSPointInRect([controlView convertPoint:currentPoint fromView:nil], cellFrame);
				if (!result) {
					done = YES;
					[self setMouseOver:NO];
				} else {
					[self setMouseOver:YES];
				}
			}
			if (done && result && ![self isContinuous]) {
				[NSApp sendAction:[self action] to:[self target] from:controlView];
			}
		} else { // show menu
			done = YES;
			result = YES;
//			[self showMenuForEvent:theEvent controlView:controlView cellFrame:cellFrame];
		}
	} // while (!done)
	return result;
}


@end


