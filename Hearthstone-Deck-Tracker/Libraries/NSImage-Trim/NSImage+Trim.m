
#import "NSImage+Trim.h"

@implementation NSImage (Trim)

/*
 * Calculates the insets of transparency around all sides of the image
 *
 * @param fullyOpaque 
 *        Whether the algorithm should consider pixels with an alpha value of something other than 255 as being transparent. Otherwise a non-zero value would be considered opaque.
 */
- (NSEdgeInsets)transparencyInsetsRequiringFullOpacity:(BOOL)fullyOpaque
{
	// Draw our image on that context
	NSInteger width  = self.size.width;
	NSInteger height = self.size.height;
	NSInteger bytesPerRow = width * (NSInteger)sizeof(uint8_t);
	
	// Allocate array to hold alpha channel
	uint8_t * bitmapData = calloc((size_t)(width * height), sizeof(uint8_t));
	
	// Create alpha-only bitmap context
	CGContextRef contextRef = CGBitmapContextCreate(bitmapData, (NSUInteger)width, (NSUInteger)height, 8, (NSUInteger)bytesPerRow, NULL, (CGBitmapInfo)kCGImageAlphaOnly);
	
    NSRect imageRect = NSMakeRect(0, 0, width, height);
    CGImageRef cgImage = [self CGImageForProposedRect:&imageRect context:NULL hints:nil];
    
	CGRect rect = CGRectMake(0, 0, width, height);
	CGContextDrawImage(contextRef, rect, cgImage);
    
	// Sum all non-transparent pixels in every row and every column
	uint16_t * rowSum = calloc((size_t)height, sizeof(uint16_t));
	uint16_t * colSum = calloc((size_t)width,  sizeof(uint16_t));
	
	// Enumerate through all pixels
	for (NSInteger row = 0; row < height; row++) {
		
		for (NSInteger col = 0; col < width; col++) {
			
			if (fullyOpaque) {
			
				// Found non-transparent pixel
				if (bitmapData[row*bytesPerRow + col] == UINT8_MAX) {
					
					rowSum[row]++;
					colSum[col]++;
					
				}
				
			} else {
				
				// Found non-transparent pixel
				if (bitmapData[row*bytesPerRow + col]) {
					
					rowSum[row]++;
					colSum[col]++;
					
				}
				
			}
			
		}
		
	}
	
	// Initialize crop insets and enumerate cols/rows arrays until we find non-empty columns or row
	NSEdgeInsets crop = NSEdgeInsetsMake(0, 0, 0, 0);
	
    // Top
	for (NSInteger i = 0; i < height; i++) {
		
		if (rowSum[i] > 0) {
			
			crop.top = i;
            break;
			
		}
		
	}
	
    // Bottom
	for (NSInteger i = height - 1; i >= 0; i--) {
		
		if (rowSum[i] > 0) {
			crop.bottom = MAX(0, height - i - 1);
            break;
		}
		
	}
	
    // Left
	for (NSInteger i = 0; i < width; i++) {
		
		if (colSum[i] > 0) {
			crop.left = i;
            break;
		}
		
	}
	
    // Right
	for (NSInteger i = width - 1; i >= 0; i--) {
		
		if (colSum[i] > 0) {
			
			crop.right = MAX(0, width - i - 1);
            break;
			
		}
	}
	
	free(bitmapData);
	free(colSum);
	free(rowSum);
	
    CGContextRelease(contextRef);
	
	return crop;
}

/*
 * Original method signature; behavior should be identical.
 */
- (NSImage *)imageByTrimmingTransparentPixels
{
	return [self imageByTrimmingTransparentPixelsRequiringFullOpacity:NO];
}

/*
 * Alternative method signature allowing for the use of cropping based on semi-transparency.
 */
- (NSImage *)imageByTrimmingTransparentPixelsRequiringFullOpacity:(BOOL)fullyOpaque
{
	if (self.size.height < 2 || self.size.width < 2) {
		
		return self;
		
	}
	
	CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
	NSEdgeInsets crop = [self transparencyInsetsRequiringFullOpacity:fullyOpaque];
	
    NSImage *img = self;
    
	if (crop.top == 0 && crop.bottom == 0 && crop.left == 0 && crop.right == 0) {
		
		// No cropping needed
		
	} else {
		
		// Calculate new crop bounds
		rect.origin.x += crop.left;
		rect.origin.y += crop.top;
		rect.size.width -= crop.left + crop.right;
		rect.size.height -= crop.top + crop.bottom;
		
		// Crop it
        NSRect imageRect = NSMakeRect(0, 0, self.size.width, self.size.height);
        CGImageRef cgImage = [self CGImageForProposedRect:&imageRect context:NULL hints:nil];
        
        CGImageRef newImage = CGImageCreateWithImageInRect(cgImage, rect);
		
        img = [[NSImage alloc] initWithCGImage:newImage size:rect.size];

	}
    
    return img;
}

@end
