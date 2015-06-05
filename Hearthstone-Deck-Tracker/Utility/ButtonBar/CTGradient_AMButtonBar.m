//
//  CTGradient_AMButtonBar.m
//  ButtonBarTest
//
//  Created by Andreas on 09.02.07.
//  Copyright 2007 Andreas Mayer. All rights reserved.
//

#import "CTGradient_AMButtonBar.h"

@interface CTGradient (Private)
- (void)addElement:(CTGradientElement*)newElement;
@end

@implementation CTGradient (AMButtonBar)

+ (id)blueButtonBarGradient
{
	id newInstance = [[[self class] alloc] init];

	CTGradientElement color1;
	color1.red = 0.65;
	color1.green = 0.65;
	color1.blue = 0.85;
	color1.alpha = 1.00;
	color1.position = 0;

	CTGradientElement color2;
	color2.red = 0.75;
	color2.green = 0.75;
	color2.blue = 0.95;
	color2.alpha = 1.00;
	color2.position = 1;

	[newInstance addElement:&color1];
	[newInstance addElement:&color2];

	return [newInstance autorelease];
}

+ (id)grayButtonBarGradient;
{
	id newInstance = [[[self class] alloc] init];
	
	CTGradientElement color1;
	color1.red = 0.75;
	color1.green = 0.75;
	color1.blue = 0.75;
	color1.alpha = 1.00;
	color1.position = 0;
	
	CTGradientElement color2;
	color2.red = 0.95;
	color2.green = 0.95;
	color2.blue = 0.95;
	color2.alpha = 1.00;
	color2.position = 1;
	
	[newInstance addElement:&color1];
	[newInstance addElement:&color2];
	
	return [newInstance autorelease];
}

+ (id)lightButtonBarGradient
{
	id newInstance = [[[self class] alloc] init];
	
	CTGradientElement color1;
	color1.red = 0.85;
	color1.green = 0.85;
	color1.blue = 0.85;
	color1.alpha = 1.00;
	color1.position = 0;
	
	CTGradientElement color2;
	color2.red = 0.95;
	color2.green = 0.95;
	color2.blue = 0.95;
	color2.alpha = 1.00;
	color2.position = 1;
	
	[newInstance addElement:&color1];
	[newInstance addElement:&color2];
	
	return [newInstance autorelease];
}


@end
