

#import <Cocoa/Cocoa.h>

@interface NSImage (Trim)

- (NSEdgeInsets)transparencyInsetsRequiringFullOpacity:(BOOL)fullyOpaque;
- (NSImage *)imageByTrimmingTransparentPixels;
- (NSImage *)imageByTrimmingTransparentPixelsRequiringFullOpacity:(BOOL)fullyOpaque;

@end
