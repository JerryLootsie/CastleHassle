//
//  LootsieRewardsScreen.m
//  Rev6
//
//  Created by Fabio Teles on 6/19/15.
//  Copyright (c) 2015 Itv. All rights reserved.
//

#import "LootsieRewardsScreen.h"
#import "LootsieRewardItem.h"
#import "Lootsie.h"
#import "MainMenu.h"

static LootsieRewardsScreen *instance = nil;

@interface LootsieRewardsScreen () <UIAlertViewDelegate>

@property (strong, nonatomic) LootsieRewardItem *currentItem;
@property (strong, nonatomic) LootsieRewardItem *nextItem;

@property (strong, nonatomic) NSArray *rewards;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation LootsieRewardsScreen

+ (LootsieRewardsScreen *)instance{
    if (instance == nil) {
        instance = [[LootsieRewardsScreen alloc] init];
    }
    return instance;
}

- (id)init {
    if (self = [super init]) {
        
        CCSprite *wall = [CCSprite spriteWithFile:@"background.jpg"];
        [wall setPosition:ccp(240,160)];
        [self addChild:wall z:0];
        
        CCLabelTTF* title = [CCLabelTTF labelWithString:@"Marketplace" fontName:@"Arial-BoldMT" fontSize:24];
        [title setColor:ccc3(255, 255, 255)];
        title.position = ccp(240,286);
        [self addChild:title z:1];
        
        CCSprite *foreground = [CCSprite spriteWithFile:@"rewards_foreground.png"];
        foreground.position = ccp(240, 160);
        [self addChild:foreground z:3];
        
        [self iconMenuItemWithIconRect:CGRectMake(144.f, 0.f, 24.f, 24.f)
                            atPosition:ccp(-205, 127)
                              selector:@selector(previousScreen:)];
        
        [self iconMenuItemWithIconRect:CGRectMake(168.f, 0.f, 24.f, 24.f)
                            atPosition:ccp(-15, -76)
                              selector:@selector(detailsCurrent:)];
        
        [self makeButtonWithString:@"Redeem"
                        atPosition:ccp(83, -76)
                      withSelector:@selector(redeemCurrent:)];
        
        self.rewards = [[Lootsie sharedInstance] getRewards];
        if (self.rewards.count > 0) {
            self.currentIndex = 0;
            [self populateCurrentReward];
        } else {
            self.currentIndex = -1;
        }
    }
    return self;
}

- (void)populateCurrentReward {
    LootsieReward *reward = [self.rewards objectAtIndex:self.currentIndex];
    ccColor4B whiteColor = ccc4(255, 255, 255, 255);
    
    self.currentItem = [LootsieRewardItem layerWithColor:whiteColor width:311 height:181 reward:reward];
    self.currentItem.position = ccp(84, 79);
    [self addChild:self.currentItem z:2];
}

- (void)redeemCurrent:(id)sender {
    LootsieReward *reward = [self.rewards objectAtIndex:self.currentIndex];
    NSString *message = [NSString stringWithFormat:@"By redeeming \"%@\" you agree to the Terms of Service:\n\n %@", reward.name, reward.tos_text];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Redeem"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Redeem", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alertView textFieldAtIndex:0] setPlaceholder:@"E-mail"];
    
    [alertView show];
    [alertView release];
}

- (void)detailsCurrent:(id)sender {
    LootsieReward *reward = [self.rewards objectAtIndex:self.currentIndex];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:reward.name
                                                        message:reward.reward_description
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
    
    [alertView show];
    [alertView release];
}

- (void)previousScreen:(id)sender
{
    NSLog(@"Previous Screen Button Pressed");
    MainMenu * main = [MainMenu instance];
    [main removeChild:self cleanup:YES];
    [main addChild:[MainMenuLayer node]];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
}

@end
