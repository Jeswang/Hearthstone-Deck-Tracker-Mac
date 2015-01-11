//
//  CardCellView.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/11.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardCellView.h"
#import "CardModel.h"

@implementation CardCellView

+ (instancetype)initWithCard:(CardModel*)card {
    CardCellView *cell = [CardCellView new];
    cell.card = card;
    return cell;
}

- (NSString*)absPath {
    static NSString *absPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *appBundle = [NSBundle mainBundle];
        absPath = [NSString stringWithFormat:@"%@/Contents/Resources/Images/", [appBundle bundlePath]];
    });
    return absPath;
}

- (NSString*)imagePath {
    NSString *cardFileName = [[[[[[self.card.englishName lowercaseString]
                                  stringByReplacingOccurrencesOfString:@" " withString:@"-"]
                                 stringByReplacingOccurrencesOfString:@":" withString:@""]
                                stringByReplacingOccurrencesOfString:@"'" withString:@"-"]
                               stringByReplacingOccurrencesOfString:@"." withString:@""]
                              stringByReplacingOccurrencesOfString:@"!" withString:@""];
    
    return [NSString stringWithFormat:@"%@/%@.png", self.absPath, cardFileName];
}

- (NSString*)framePath {
    return [NSString stringWithFormat:@"%@/%@.png", self.absPath, @"frame"];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    //CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    NSImage* image = [[NSImage alloc] initWithContentsOfFile:[self imagePath]];
    [image drawInRect:CGRectMake(104, 1, 110, 34)];
    
    NSImage* frame = [[NSImage alloc] initWithContentsOfFile:[self framePath]];
    [frame drawInRect:CGRectMake(1, 0, 218, 35)];
    
    NSMutableAttributedString *costLabel = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", self.card.cost]];
    
    NSRange rangeOfCost = NSMakeRange(0,[costLabel length]);
    
    NSFont *font = [NSFont fontWithName:@"BelweBT-Bold" size:20];
    [costLabel setAttributes:@{NSFontAttributeName : font,
                               NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-1.0],
                               NSStrokeColorAttributeName:[NSColor blackColor],
                               NSForegroundColorAttributeName: [NSColor whiteColor],
                               } range:rangeOfCost];
    [costLabel setAlignment:NSCenterTextAlignment range:rangeOfCost];
    [costLabel drawInRect:CGRectMake(0, 0, 34, 37)];
    
    NSMutableAttributedString *titleLabel = [[NSMutableAttributedString alloc] initWithString:self.card.name];
    rangeOfCost = NSMakeRange(0,[titleLabel length]);
    NSFont *font2 = [NSFont fontWithName:@"GBJenLei-Medium" size:18];
    [titleLabel setAttributes:@{NSFontAttributeName : font2,
                               NSStrokeColorAttributeName:[NSColor blackColor],
                               NSForegroundColorAttributeName: [NSColor whiteColor],
                               } range:rangeOfCost];
    [titleLabel drawInRect:CGRectMake(37, 0, 184, 30) ];

}

@end
