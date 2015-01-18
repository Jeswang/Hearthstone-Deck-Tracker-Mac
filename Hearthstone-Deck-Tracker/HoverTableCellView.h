//
// Created by jeswang on 15/1/17.
// Copyright (c) 2015 rainy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol HoverCellProtocal <NSObject>

- (void)hoverCell:(NSTableCellView *)cell mouseInside:(BOOL)mouseInside;

@end

@interface HoverTableCellView : NSTableCellView {
@private
    BOOL mouseInside;
    NSTrackingArea *trackingArea;
}

@property(nonatomic, weak) id<HoverCellProtocal> delegate;

@end