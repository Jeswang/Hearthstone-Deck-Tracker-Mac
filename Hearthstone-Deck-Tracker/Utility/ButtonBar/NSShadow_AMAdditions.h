//
//  NSShadow_AMAdditions.h
//  ButtonBarTest
//
//  Created by Andreas on 10.02.07.
//  Copyright 2007 Andreas Mayer. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSShadow (AMAdditions)

+ (NSShadow *)shadowWithColor:(NSColor *)color blurRadius:(float)radius offset:(NSSize)offset;


@end
