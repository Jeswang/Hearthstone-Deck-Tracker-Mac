//
//  CardCellView.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/11.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardCellView.h"
#import "CardModel.h"
#import "Configuration.h"

@implementation CardCellView

+ (instancetype)initWithCard:(CardModel*)card {
    CardCellView *cell = [CardCellView new];
    
    cell.card = card;
    return cell;
}

- (void)mouseUp:(NSEvent *)theEvent {
    NSLog(@"Remove Card %@", self.card.cardId);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveCard" object:self.card.cardId];
}

- (NSString*)imagePath {
    NSString *cardFileName = [[[[[[self.card.englishName lowercaseString]
                                  stringByReplacingOccurrencesOfString:@" " withString:@"-"]
                                 stringByReplacingOccurrencesOfString:@":" withString:@""]
                                stringByReplacingOccurrencesOfString:@"'" withString:@"-"]
                               stringByReplacingOccurrencesOfString:@"." withString:@""]
                              stringByReplacingOccurrencesOfString:@"!" withString:@""];
    
    return [NSString stringWithFormat:@"%@/small/%@.png", IMAGE, cardFileName];
}

- (NSString*)framePath {
    return [self pngPathWithName:@"frame"];
}

- (NSString*)pngPathWithName:(NSString*)fileName {
    return [NSString stringWithFormat:@"%@/%@.png", IMAGE, fileName];
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
    NSRange rangeOfTitle = NSMakeRange(0,[titleLabel length]);

    
    NSFont *font2;
    if ([Configuration instance].isAsiaLanguage) {
        font2 = [NSFont fontWithName:@"GBJenLei-Medium" size:18];
    }
    else {
        font2 = [NSFont fontWithName:@"BelweBT-Bold" size:12];
    }
    
    [titleLabel setAttributes:@{NSFontAttributeName : font2,
                                NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-0.5],
                                NSStrokeColorAttributeName:[NSColor blackColor],
                                NSForegroundColorAttributeName: [NSColor whiteColor],
                                } range:rangeOfTitle];
    
    [titleLabel drawInRect:CGRectMake(37, 0, 184, 30) ];
    
    if(self.card.count >= 2 || [self.card.rarity  isEqual: @"Legendary"]) {
        NSImage* frameCountBox = [[NSImage alloc] initWithContentsOfFile:[self pngPathWithName:@"frame_countbox"]];
        [frameCountBox drawInRect:CGRectMake(189, 5, 25, 24)];
        
        if(self.card.count >= 2 && self.card.count <= 9)
        {
            NSImage* extraInfo = [[NSImage alloc] initWithContentsOfFile:[self pngPathWithName:[NSString stringWithFormat:@"frame_%ld", (long)self.card.count]]];
            [extraInfo drawInRect:CGRectMake(194, 8, 18, 21)];
        }
        else
        {
            NSImage* extraInfo = [[NSImage alloc] initWithContentsOfFile:[self pngPathWithName:@"frame_legendary"]];
            [extraInfo drawInRect:CGRectMake(194, 8, 18, 21)];
        }
    }
    
    if ([Configuration instance].fadeCards) {
        if (self.card.count <= 0) {
            self.alphaValue = 0.4;
        }
        else {
            self.alphaValue = 1.0;
        }
    }
}

@end
