//
//  NSColor_AMAdditions.h
//  PlateControl
//
//  Created by Andreas on Sat Jan 17 2004.
//  Copyright (c) 2004 Andreas Mayer. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSColor (AMAdditions)

+ (NSColor *)lightYellowColor;

+ (NSColor *)am_toolTipColor;

+ (NSColor *)am_toolTipTextColor;

- (NSColor *)accentColor;

- (NSColor *)lighterColor;

- (NSColor *)disabledColor;


@end
