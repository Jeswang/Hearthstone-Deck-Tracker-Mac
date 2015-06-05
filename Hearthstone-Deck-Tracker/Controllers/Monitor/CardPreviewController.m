//
//  CardPreviewController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/1/17.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardPreviewController.h"
#import "ScaleImageView.h"
#import "NSImage+Trim.h"

#define HEARTHHEAD_IMAGE_TEMPLATE @"http://wow.zamimg.com/images/hearthstone/cards/enus/original/%@.png"
#define CN_CARD_IMAGE_TEMPLATE @"http://lai1tong.com/cards/CN/%@.png"
#define LOCAL_IMAGE_TEMPLATE @"/Users/jeswang/Documents/App/Hearthstone-Deck-Tracker/Hearthstone-Inject/Scripts/t_cards/%@.png"

@interface CardPreviewController ()
@property(nonatomic, weak) IBOutlet NSImageView *cardImage;
@end

@implementation CardPreviewController

- (void)windowDidLoad {
    [super windowDidLoad];
    // Do view setup here.
    //[self.cardImage setImageAlignment:NSImageAlignTopRight];
    [self.cardImage setImageScaling:NSImageScaleProportionallyUpOrDown];
    self.cardImage.webCacheDelegate = self;
}

- (void)loadCardByCardId:(NSString *)cardId {
#ifdef DEBUG
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:LOCAL_IMAGE_TEMPLATE, cardId]];
    [self.cardImage setImage:image];
    return;
#endif
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:CN_CARD_IMAGE_TEMPLATE, cardId]];
    [self.cardImage setImage:[NSImage imageNamed:@"Card_back-Default"]];
    //[self.cardImage setBounds:CGRectMake(0, 0, 200, 279)];

    [self.cardImage setImageURL:imageURL];
}

- (void)imageView:(NSImageView *)imageView downloadImageSuccessed:(NSImage *)image data:(NSData *)data {
    NSImage *scaleToFillImage = [image imageByTrimmingTransparentPixelsRequiringFullOpacity:YES];
    
    [self.cardImage setImage:scaleToFillImage];
}

- (void)imageViewDownloadImageFailed:(NSImageView *)imageView {
    
}


@end
