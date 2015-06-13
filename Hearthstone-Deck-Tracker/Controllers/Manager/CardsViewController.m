//
//  CardsViewController.m
//  Hearthstone-Deck-Tracker
//
//  Created by jeswang on 15/5/3.
//  Copyright (c) 2015年 rainy. All rights reserved.
//

#import "CardsViewController.h"
#import "CardModel.h"
#import "CardCollectionViewItem.h"

#import "AMButtonBar.h"
#import "AMButtonBarItem.h"
#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
#import "NSGradient_AMButtonBar.h"
#else
#import "CTGradient.h"
#import "CTGradient_AMButtonBar.h"
#endif

#import "GameString.h"

@interface CardsViewController () {
    IBOutlet MGScopeBar * mgScopeBar;
    IBOutlet NSView * mgAccessoryView;
    IBOutlet NSSearchField *searchField;
    
    NSArray *labels;
    NSMutableArray *filters;
    NSMutableDictionary *allCardItems;
}
@property (nonatomic, weak) IBOutlet NSCollectionView *cardCollectionView;
@property (nonatomic, strong) NSMutableArray* cards;
@property (nonatomic, strong) CardFilter *titleFilter;

@end

@implementation CardsViewController

- (void)awakeFromNib{
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *className;
    NSDictionary *cardRarity;
    NSDictionary *cardEffect;
    NSDictionary *cardRace;
    NSDictionary *cardType;
    NSDictionary *cardSet;
    NSDictionary *cardCost;
    
    className = @{
                  @"0 all": @"All",
                  @"1 Shaman": @"GLOBAL_CLASS_SHAMAN",
                  @"2 Priest": @"GLOBAL_CLASS_PRIEST",
                  @"3 Rogue": @"GLOBAL_CLASS_ROGUE",
                  @"4 Mage": @"GLOBAL_CLASS_MAGE",
                  @"5 Warrior": @"GLOBAL_CLASS_WARRIOR",
                  @"6 Paladin": @"GLOBAL_CLASS_PALADIN",
                  @"a Neutral": @"GLOBAL_CLASS_NEUTRAL",
                  @"7 Hunter": @"GLOBAL_CLASS_HUNTER",
                  @"8 Druid": @"GLOBAL_CLASS_DRUID",
                  @"9 Warlock": @"GLOBAL_CLASS_WARLOCK"
                  };
    cardRarity = @{
                   @"0 all": @"All",
                   @"5 Legendary": @"GLOBAL_RARITY_LEGENDARY",
                   @"4 Epic": @"GLOBAL_RARITY_EPIC",
                   @"3 Rare": @"GLOBAL_RARITY_RARE",
                   @"1 Free": @"GLOBAL_RARITY_FREE",
                   @"2 Common": @"GLOBAL_RARITY_COMMON"
                   };
    
    cardEffect = @{
                   @"all": @"全部",
                   @"secret": @"奥秘",
                   @"charge": @"冲锋",
                   @"death_rattle": @"亡语",
                   @"windfury": @"风怒",
                   @"enrage": @"激怒",
                   @"divine_shield": @"圣盾",
                   @"stealth": @"潜行",
                   @"choice": @"抉择",
                   @"taunt": @"嘲讽",
                   @"overload": @"过载",
                   @"battlecry": @"战吼",
                   @"combo": @"连击",
                   @"spell_damage": @"法术伤害",
                   @"silence": @"沉默"
                   };
    
    cardRace =  @{
                  @"all": @"全部",
                  @"pirate": @"海盗",
                  @"murloc": @"鱼人",
                  @"demon": @"恶魔",
                  @"beast": @"野兽",
                  @"dragon": @"龙"
                  };
    
    cardType = @{
                 @"0 all": @"All",
                 @"2 Spell": @"GLOBAL_CARDTYPE_SPELL",
                 @"1 Minion": @"GLOBAL_CARDTYPE_MINION",
                 @"3 Weapon": @"GLOBAL_CARDTYPE_WEAPON"
                 };
    
    cardSet = @{
                @"all": @"全部",
                @"reward": @"纪念",
                @"basic": @"基本级",
                @"missions": @"奖励",
                @"expert": @"专家级"};
    
    cardCost = @{
                 @"0 all":@"All",
                 @"1":@"1",
                 @"2":@"2",
                 @"3":@"3",
                 @"4":@"4",
                 @"5":@"5",
                 @"6":@"6",
                 @"7":@"7 or more"
                 };
    
    filters = [[NSMutableArray alloc] initWithArray:@[
               [CardFilter filterWithName:@"playerClass" label:@"Hero" dict:className],
               [CardFilter filterWithName:@"rarity" label:@"Rarity" dict:cardRarity],
               [CardFilter filterWithName:@"cardType" label:@"Type" dict:cardType],
               [CardFilter filterWithName:@"cost" label:@"Cost" dict:cardCost],
               //[CardFilter filterWithName:@"cardEffect" label:@"属性" dict:cardEffect],
               //[CardFilter filterWithName:@"cardRace" label:@"种族" dict:cardRace]
               ]];
    
    self.titleFilter = [CardFilter new];
    self.titleFilter.name = @"name";
    self.titleFilter.selectedKey = @"";

    // Do view setup here.
    allCardItems = [NSMutableDictionary new];

    NSMutableArray *cards = [[CardModel actualCards] mutableCopy];
    NSMutableArray *cardsModels = [NSMutableArray new];
    for (CardModel *card in cards) {
        CardCollectionViewItem *item = [CardCollectionViewItem new];
        [item setCardImageWithId:card.cardId];
        [cardsModels addObject:item];
        [allCardItems setObject:item forKey:card.cardId];
    }
    [self.cardCollectionView setContent:cardsModels];
    
    [mgScopeBar reloadData];
    
    
    @weakify(self)
    [searchField.rac_textSignal subscribeNext:^(id x) {
        @strongify(self)
        self.titleFilter.selectedKey = x;
        [self reloadWithFilter];
    }];
    
    [NC addObserver:self selector:@selector(reloadContent) name:kCountryLanguageChanged object:nil];
}

- (void)reloadContent {
    [mgScopeBar reloadData];
    //[mgScopeBar adjustSubviews];
}

- (NSUInteger)numberOfGroupsInScopeBar:(MGScopeBar *)theScopeBar;
{
    return [filters count];
}

- (NSArray *)scopeBar:(MGScopeBar *)theScopeBar itemIdentifiersForGroup:(NSInteger)groupNumber;
{
    NSDictionary *dic = [[filters objectAtIndex:groupNumber] dict];
    return [[dic allKeys] sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString* s1 = obj1, *s2 = obj2;
        return [s1 compare:s2];
    }];
}

- (NSString *)scopeBar:(MGScopeBar *)theScopeBar labelForGroup:(NSInteger)groupNumber;
{
    NSString *label = [[filters objectAtIndex:groupNumber] label];
    return [NSString stringWithFormat:@"%@:", label];
}


- (MGScopeBarGroupSelectionMode)scopeBar:(MGScopeBar *)theScopeBar selectionModeForGroup:(NSInteger)groupNumber;
{

    return MGRadioSelectionMode;
}

- (NSString *)scopeBar:(MGScopeBar *)theScopeBar titleOfItem:(NSString *)identifier inGroup:(NSInteger)groupNumber;
{
    NSDictionary *dic = [[filters objectAtIndex:groupNumber] dict];
    return [GameString valueForKey:[dic objectForKey:identifier]];
}

- (NSImage *)scopeBar:(MGScopeBar *)theScopeBar imageForItem:(NSString *)identifier inGroup:(NSInteger)groupNumber;
{
    return nil;
}


- (NSMenu *)scopeBar:(MGScopeBar *)theScopeBar menuForItem:(NSString *)identifier inGroup:(NSInteger)groupNumber;
{
    return nil;
}

- (BOOL)scopeBar:(MGScopeBar *)theScopeBar showSeparatorBeforeGroup:(NSInteger)groupNumber;
{
    if (groupNumber == 0) {
        return NO;
    }
    
    return YES;
}


- (NSView *)accessoryViewForScopeBar:(MGScopeBar *)theScopeBar;
{
    return mgAccessoryView;
}


- (void)scopeBar:(MGScopeBar *)theScopeBar selectedStateChanged:(BOOL)selected forItem:(NSString *)identifier inGroup:(NSInteger)groupNumber;
{
    //NSLog(@"MG item selection changed");
    
    [[filters objectAtIndex:groupNumber] setSelectedKey:identifier];
    
    [self reloadWithFilter];
}

- (void)reloadWithFilter {
    NSArray *cards = [CardModel cardWithFilters:[filters arrayByAddingObject:self.titleFilter]];
    NSMutableArray *cardsModels = [NSMutableArray new];
    
    for (CardModel *card in cards) {
        id item = [allCardItems objectForKey:card.cardId];
        [cardsModels addObject:item];
    }
    
    [self.cardCollectionView setContent:cardsModels];
}

@end

