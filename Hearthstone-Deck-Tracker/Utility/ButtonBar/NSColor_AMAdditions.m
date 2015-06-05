//
//  NSColor_AMAdditions.m
//  PlateControl
//
//  Created by Andreas on Sat Jan 17 2004.
//  Copyright (c) 2004 Andreas Mayer. All rights reserved.
//
//	2011-08-08	changed some variables from float to double to satisfy the compiler
//	2011-08-12	changed to CGFloat instead

#import "NSColor_AMAdditions.h"


@interface NSColor (AMAdditions_AppKitPrivate)
+ (NSColor *)toolTipColor;
+ (NSColor *)toolTipTextColor;
@end


@implementation NSColor (AMAdditions)

+ (NSColor *)lightYellowColor
{
	return [NSColor colorWithCalibratedHue:0.2 saturation:0.2 brightness:1.0 alpha:1.0];
}

+ (NSColor *)am_toolTipColor
{
	NSColor *result;
	if ([NSColor respondsToSelector:@selector(toolTipColor)]) {
		result = [NSColor toolTipColor];
	} else {
		result = [NSColor lightYellowColor];
	}
	return result;
}

+ (NSColor *)am_toolTipTextColor
{
	NSColor *result;
	if ([NSColor respondsToSelector:@selector(toolTipTextColor)]) {
		result = [NSColor toolTipTextColor];
	} else {
		result = [NSColor blackColor];
	}
	return result;
}

- (NSColor *)accentColor
{
	NSColor *result;
	CGFloat hue;
	CGFloat saturation;
	CGFloat brightness;
	CGFloat alpha;
	[[self  colorUsingColorSpaceName:NSDeviceRGBColorSpace] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	if (brightness <= 0.3) {
		[[[NSColor colorForControlTint:[NSColor currentControlTint]] colorUsingColorSpaceName:NSDeviceRGBColorSpace] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
		saturation = 1.0;
		brightness = 1.0;
	} else {
		//if (saturation > 0.3) {
		brightness = brightness/2.0;
		//}
		saturation = 1.0;
	}
	result = [NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:alpha];
	return result;
}

- (NSColor *)lighterColor
{
	NSColor *result;
	CGFloat hue;
	CGFloat saturation;
	CGFloat brightness;
	CGFloat alpha;
	[[self  colorUsingColorSpaceName:NSDeviceRGBColorSpace] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	if (brightness > 0.4) {
		if (brightness < 0.90) {
			brightness += 0.1+(brightness*0.3);
		} else {
			brightness = 1.0;
			if (saturation > 0.12) {
				saturation = MAX(0.0, saturation-0.1-(saturation/2.0));
			} else {
				saturation += 0.25;
			}
		}
	} else {
		brightness = 0.6;
	}
	result = [NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:alpha];
	return result;
}

- (NSColor *)disabledColor
{
	int alpha = [self alphaComponent];
	return [self colorWithAlphaComponent:alpha*0.5];
}


@end
