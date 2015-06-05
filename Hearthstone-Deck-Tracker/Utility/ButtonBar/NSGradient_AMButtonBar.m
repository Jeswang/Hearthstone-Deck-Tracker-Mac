//
//  NSGradient_AMButtonBar.m
//  ButtonBarTest
//
//  Created by Andreas on 18.02.10.
//  Copyright 2010 Andreas Mayer. All rights reserved.
//

#import "NSGradient_AMButtonBar.h"


@implementation NSGradient (AMButtonBar)


+ (id)blueButtonBarGradient
{
	NSGradient *result;
	
	NSColor *color1 = [NSColor colorWithCalibratedRed:0.65 green:0.65 blue:0.85 alpha:1.00];
	NSColor *color2 = [NSColor colorWithCalibratedRed:0.75 green:0.75 blue:0.95 alpha:1.00];
	result = [[NSGradient alloc] initWithColors:[NSArray arrayWithObjects:color1, color2, nil]];
	
	return [result autorelease];
}

+ (id)grayButtonBarGradient;
{
	NSGradient *result;
	
	NSColor *color1 = [NSColor colorWithCalibratedRed:0.75 green:0.75 blue:0.85 alpha:1.00];
	NSColor *color2 = [NSColor colorWithCalibratedRed:0.95 green:0.95 blue:0.95 alpha:1.00];
	result = [[NSGradient alloc] initWithColors:[NSArray arrayWithObjects:color1, color2, nil]];
	
	return [result autorelease];
}

+ (id)lightButtonBarGradient
{
	NSGradient *result;
	
	NSColor *color1 = [NSColor colorWithCalibratedRed:0.85 green:0.85 blue:0.85 alpha:1.00];
	NSColor *color2 = [NSColor colorWithCalibratedRed:0.95 green:0.95 blue:0.95 alpha:1.00];
	result = [[NSGradient alloc] initWithColors:[NSArray arrayWithObjects:color1, color2, nil]];
	
	return [result autorelease];
}


@end
