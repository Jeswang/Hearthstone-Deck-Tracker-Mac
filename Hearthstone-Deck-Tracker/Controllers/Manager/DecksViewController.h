//
//  DecksViewController.h
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/5/3.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PXSourceList.h"

@interface DecksViewController : NSViewController <PXSourceListDataSource, PXSourceListDelegate>

- (IBAction)addButtonAction:(id)sender;
- (IBAction)removeButtonAction:(id)sender;

@end
