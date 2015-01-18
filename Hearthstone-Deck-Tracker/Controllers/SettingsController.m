//
//  SettingsController.m
//  Hearthstone-Deck-Tracker
//
//  Created by Benjamin Michotte on 18/01/15.
//  Copyright (c) 2015 rainy. All rights reserved.
//

#import "SettingsController.h"
#import "Configuration.h"

@interface SettingsController ()
{
    NSDictionary *_languages;
}

@property (strong) IBOutlet NSPopUpButton *languageChooser;
@property (strong) IBOutlet NSPopUpButton *onCardDraw;

@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];

    _languages = @{
                   @"deDE": @"de_DE",
                   @"enGB": @"en_GB",
                   @"enUS": @"en_US",
                   @"esES": @"es_ES",
                   @"esMX": @"es_MX",
                   @"frFR": @"fr_FR",
                   @"itIT": @"it_IT",
                   @"koKR": @"ko_KR",
                   @"plPL": @"pl_PL",
                   @"ptBR": @"pt_BR",
                   @"ptPT": @"pt_PT",
                   @"ruRU": @"ru_RU",
                   @"zhCN": @"zh_CN",
                   @"zhTW": @"zh_TW"
                   };
    
    [self.languageChooser removeAllItems];
    NSLocale *locale;
    NSMutableArray *locales = [NSMutableArray new];
    for (NSString *hsLocale in [_languages allValues]) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:hsLocale];
        [locales addObject:[locale displayNameForKey:NSLocaleIdentifier value:hsLocale]];
    }
    [self.languageChooser addItemsWithTitles:locales];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    if ([Configuration instance].countryLanguage) {
        NSInteger index = [[_languages allKeys] indexOfObject:[Configuration instance].countryLanguage];
        [self.languageChooser selectItemAtIndex:index];
     }
    
    [self.onCardDraw selectItemAtIndex:[Configuration instance].fadeCards ? 1 : 0];
}

- (IBAction)languageChoose:(id)sender {
    [Configuration instance].countryLanguage = [_languages allKeys][[self.languageChooser indexOfSelectedItem]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCountryLanguageChanged object:nil];
}

- (IBAction)onCardDraw:(id)sender {
    [Configuration instance].fadeCards = [self.onCardDraw indexOfSelectedItem] == 1;
    [[NSNotificationCenter defaultCenter] postNotificationName:kFadeCardsChanged object:nil];
}

@end
