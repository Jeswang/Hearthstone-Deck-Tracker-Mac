//
//  KPCScaleToFillNSImageView.m
//
//  Created by onekiloparsec on 4/5/14.
//  MIT Licence
//

#import "ScaleImageView.h"

@implementation ScaleImageView

- (void)setImage:(NSImage *)image
{

	NSImage *scaleToFillImage = [NSImage imageWithSize:self.bounds.size
											   flipped:NO
                                        drawingHandler:^BOOL(NSRect dstRect) {
                                            [image drawInRect:self.bounds];
                                            return YES;
                                        }];

		[scaleToFillImage setCacheMode:NSImageCacheNever]; // Hence it will automatically redraw with new frame size of the image view.

        [super setImage:scaleToFillImage];
}

@end
