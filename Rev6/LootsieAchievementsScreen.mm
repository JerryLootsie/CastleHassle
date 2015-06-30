//
//  LootsieAchievementsScreen.m
//  Rev6
//
//  Created by Fabio Teles on 6/19/15.
//  Copyright (c) 2015 Itv. All rights reserved.
//

#import "LootsieAchievementsScreen.h"
#import "Lootsie.h"
#import "MainMenu.h"

static LootsieAchievementsScreen *instance = nil;

@interface LootsieAchievementsScreen() {
    BOOL updatingAchievements;
}

@property (strong, nonatomic) CCLayer *achievementsHolder;

@end

@implementation LootsieAchievementsScreen

+ (LootsieAchievementsScreen *)instance{
    if (instance == nil) {
        instance = [[LootsieAchievementsScreen alloc] init];
    }
    return instance;
}

- (id)init {
    if (self = [super init]) {
        
        CCSprite *wall = [CCSprite spriteWithFile:@"background.jpg"];
        [wall setPosition:ccp(240,160)];
        [self addChild:wall z:0];
        
        CCSprite* navBack = sprite(@"menuBack.png");
        [navBack setPosition:ccp(240, 160)];
        [self addChild:navBack z:0];
        
        CCLabelTTF* title = [CCLabelTTF labelWithString:@"Achievements" fontName:@"Arial-BoldMT" fontSize:24];
        [title setColor:ccc3(15, 147, 222)];
        title.position = ccp(240,286);
        [self addChild:title];
        
        ccColor4B ribbonColor = ccc4(255, 255, 255, 255);
        CCRibbon *ribbon = [CCRibbon ribbonWithWidth:5 image:@"ribbon.png" length:10.0 color:ribbonColor fade:1.f];
        ribbon.position = ccp(0, 262);
        [self addChild:ribbon z:8];
        [ribbon addPointAt:ccp(12,0) width:2];
        [ribbon addPointAt:ccp(468,0) width:2];
        
        [self iconMenuItemWithIconRect:CGRectMake(144.f, 0.f, 24.f, 24.f)
                            atPosition:ccp(-205, 127)
                              selector:@selector(previousScreen:)];
        
        [self updateAchievements];
    }
    return self;
}

- (void)updateAchievements {
    if (updatingAchievements) {
        return;
    }
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    ServiceCallback achievementCallback = ^(BOOL success, id result, NSString* errorMessage, NSInteger statusCode) {
        if (success) {
            NSArray *allAchievements = (NSArray *)result;
            
            [weakSelf displayAchievements:allAchievements];
            
        } else {
            NSLog(@"LootsieAchievements: Failed to retieve achievements: %@", errorMessage);
        }
        updatingAchievements = NO;
    };
    
    updatingAchievements = YES;
    
    // fetch all achievements
    [[Lootsie sharedInstance] getUserAchievements:achievementCallback];
}

- (void)displayAchievements:(NSArray *)achievements {
    if (self.achievementsHolder) {
        [self.achievementsHolder removeAllChildrenWithCleanup:YES];
    } else {
        self.achievementsHolder = [CCLayer node];
        self.achievementsHolder.anchorPoint = ccp(0.f, 0.f);
        self.achievementsHolder.position = ccp(12.f, 12.f);
        
        [self addChild:self.achievementsHolder z:6];
    }
    
    NSDictionary *iconRects = @{
                                 @"applaunch": [NSValue valueWithCGRect:CGRectMake(0.f, 0.f, 45.f, 34.f)],
                                 @"castlehit": [NSValue valueWithCGRect:CGRectMake(0.f, 34.f, 45.f, 35.f)],
                                 @"winGame": [NSValue valueWithCGRect:CGRectMake(0.f, 69.f, 45.f, 31.f)],
                                 @"loseGame": [NSValue valueWithCGRect:CGRectMake(0.f, 100.f, 45.f, 36.f)]
                                 };
    
    CCLayer *row;
    NSUInteger i = 0;
    for (LootsieAchievement *item in achievements) {
        CGRect rect = [[iconRects objectForKey:item.achievement_id] CGRectValue];
        row = [self achievementRowWithData:item iconRect:rect];
        row.anchorPoint = ccp(0.f, 1.f);
        row.position = ccp(12.f, 195.f - 56.f * i);
        [self.achievementsHolder addChild:row];
        i++;
        if (i >= 4) break;
    }
}

- (CCLayer *)achievementRowWithData:(LootsieAchievement *)achievement iconRect:(CGRect)iconRect {
    
    CCLayer *row = [CCLayer node];
    
    // icon
    if (!achievement.is_achieved) {
        iconRect.origin.x = 45.f;
    }
    CCSprite *sprite = spriteWithRect(@"achievements.png", iconRect);
    sprite.position = ccp(30.f, 28.f);
    [row addChild:sprite z:0];
    
    // title
    CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:achievement.name fontName:@"Arial Rounded MT Bold" fontSize:18.f];
    titleLabel.anchorPoint = ccp(0.f, 0.5f);
    titleLabel.position = ccp(72.f, 35.f);
    [titleLabel setColor:ccc3(15, 147, 222)];
    [row addChild:titleLabel z:0];
    
    // description
    CCLabelTTF* descLabel = [CCLabelTTF labelWithString:achievement.achievment_description fontName:@"Arial Rounded MT Bold" fontSize:12.f];
    descLabel.anchorPoint = ccp(0.f, 0.5f);
    descLabel.position = ccp(72.f, 15.f);
    [descLabel setColor:ccc3(15, 147, 222)];
    [row addChild:descLabel z:0];
    
    // points
    CCLabelTTF* pointsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%ld CP", (long)achievement.lp] dimensions:CGSizeZero alignment:NSTextAlignmentRight fontName:@"Arial Rounded MT Bold" fontSize:26.f];
    pointsLabel.anchorPoint = ccp(1.f, .5f);
    pointsLabel.position = ccp(426.f, 28.f);
    [pointsLabel setColor:ccc3(15, 147, 222)];
    [row addChild:pointsLabel z:0];
    
    // bottom line
    ccColor4B ribbonColor = ccc4(255, 255, 255, 255);
    CCRibbon *ribbon = [CCRibbon ribbonWithWidth:5 image:@"ribbon.png" length:10.0 color:ribbonColor fade:1.f];
    [row addChild:ribbon z:8];
    [ribbon addPointAt:ccp(-12,0) width:2];
    [ribbon addPointAt:ccp(444,0) width:2];
    
    return row;
}

- (void)previousScreen:(id)sender
{
    NSLog(@"Previous Screen Button Pressed");
    MainMenu * main = [MainMenu instance];
    [main removeChild:self cleanup:YES];
    [main addChild:[MainMenuLayer node]];
}

@end
