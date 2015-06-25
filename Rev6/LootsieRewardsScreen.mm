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

@property (strong, nonatomic) UISwipeGestureRecognizer *leftSwipe;
@property (strong, nonatomic) UISwipeGestureRecognizer *rightSwipe;

@property (strong, nonatomic) NSArray *rewards;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) BOOL animating;

@end

@implementation LootsieRewardsScreen

+ (LootsieRewardsScreen *)instance {
    if (instance == nil) {
        instance = [[LootsieRewardsScreen alloc] init];
    }
    return instance;
}

- (void)dealloc {
    [super dealloc];

    [_leftSwipe release];
    [_rightSwipe release];
    
    _leftSwipe = nil;
    _rightSwipe = nil;
}

- (id)init {
    if (self = [super init]) {
        _gameMode = NO;
        // background
        CCSprite *wall = [CCSprite spriteWithFile:@"background.jpg"];
        [wall setPosition:ccp(240,160)];
        [self addChild:wall z:0];
        
        // title
        CCLabelTTF* title = [CCLabelTTF labelWithString:@"Marketplace" fontName:@"Arial-BoldMT" fontSize:24];
        [title setColor:ccc3(255, 255, 255)];
        title.position = ccp(240,286);
        [self addChild:title z:1];
        
        // foreground
        CCSprite *foreground = [CCSprite spriteWithFile:@"rewards_foreground.png"];
        foreground.position = ccp(240, 160);
        [self addChild:foreground z:3];
        
        // buttons
        [self iconMenuItemWithIconRect:CGRectMake(144.f, 0.f, 24.f, 24.f)
                            atPosition:ccp(-205, 127)
                              selector:@selector(previousScreen:)];
        
        [self iconMenuItemWithIconRect:CGRectMake(168.f, 0.f, 24.f, 24.f)
                            atPosition:ccp(-15, -76)
                              selector:@selector(detailsCurrent:)];
        
        [self makeButtonWithString:@"Redeem"
                        atPosition:ccp(83, -76)
                      withSelector:@selector(redeemCurrent:)];
        
        // rewards
        self.rewards = [[Lootsie sharedInstance] getRewards];
        if (self.rewards.count > 0) {
            self.currentIndex = 0;
            [self populateCurrentReward];
            
            // gestures
            if (self.rewards.count > 1) {
                self.leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
                self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
                self.leftSwipe.numberOfTouchesRequired = 1;
                
                self.rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
                self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
                self.rightSwipe.numberOfTouchesRequired = 1;
            }
        } else {
            self.currentIndex = -1;
        }
        
    }
    return self;
}

- (void)onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:self.leftSwipe];
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:self.rightSwipe];
}

- (void)onExit {
    [super onExit];
    
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:self.leftSwipe];
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:self.rightSwipe];
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
    NSString *message = [NSString stringWithFormat:@"By redeeming \"%@\" you agree to the Terms of Service", reward.name];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Redeem"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Redeem", @"Terms of Service", nil];
    
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
    NSLog(@"Previous Screen Button Pressed, GAME MODE: %@", (self.gameMode ? @"YES" : @"NO"));
    
    if (!self.gameMode) {
        MainMenu * main = [MainMenu instance];
        [main addChild:[MainMenuLayer node]];
    }
    
    if (self.closeBlock) self.closeBlock();
    self.closeBlock = nil;
    
    [self removeFromParentAndCleanup:YES];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

#pragma mark - Gestures
- (void)onSwipe:(UISwipeGestureRecognizer *)gesture {
    if (self.animating) return;
    
    NSInteger factor = (gesture.direction == UISwipeGestureRecognizerDirectionLeft ? 1 : -1);
    NSInteger nextIndex = self.currentIndex + 1 * factor;
    if (nextIndex < 0) nextIndex = self.rewards.count-1;
    if (nextIndex >= self.rewards.count) nextIndex = 0;
    
    LootsieReward *reward = [self.rewards objectAtIndex:nextIndex];
    ccColor4B whiteColor = ccc4(255, 255, 255, 255);
    
    self.nextItem = [LootsieRewardItem layerWithColor:whiteColor width:311 height:181 reward:reward];
    self.nextItem.position = ccp(84 + 480 * factor, 79);
    [self addChild:self.nextItem z:2];
    
    self.animating = YES;
    __unsafe_unretained __typeof(self) unownedSelf = self;
//    CCEaseIn *moveByAction = ;
    [self.currentItem runAction:[CCEaseIn actionWithAction:[CCMoveBy actionWithDuration:0.4 position:ccp(480 * factor * -1, 0)] rate:2]];
    [self.nextItem runAction:[CCSequence actions:[CCEaseIn actionWithAction:[CCMoveBy actionWithDuration:0.5 position:ccp(480 * factor * -1, 0)] rate:2], [CCCallBlock actionWithBlock:^{
        [unownedSelf.currentItem removeFromParentAndCleanup:YES];
        unownedSelf.currentItem = unownedSelf.nextItem;
        unownedSelf.nextItem = nil;
        unownedSelf.animating = NO;
    }], nil]];
    
    self.currentIndex = nextIndex;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    LootsieReward *reward = [self.rewards objectAtIndex:self.currentIndex];
    NSString *email = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    if ([title isEqualToString:@"Redeem"]) {
        // if text input present, go for redemption
        if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
            
            // validate e-mail
            if (![self validateEmail:email]) {
                [[[[UIAlertView alloc] initWithTitle:@"Invalid E-mail"
                                             message:@"Please enter a valid e-mail to receive the reward"
                                            delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"Ok", nil] autorelease] show];
                return;
            }
            
            // redeem reward
            ServiceCallback redeemRewardCallback = ^(BOOL success, id result, NSString* errorMessage, NSInteger statusCode) {
                
                NSString *userMessage, *title;
                if (success) {
                    title = @"Reddeem";
                    userMessage = @"Redeemed Successfully!";
                } else {
                    title = @"Error";
                    userMessage = @"Failed to Redeem!";
                }
                
                 [[[[UIAlertView alloc] initWithTitle:title
                                              message:userMessage
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:@"Ok", nil] autorelease] show];
            };
            [[Lootsie sharedInstance] redeemReward:reward.reward_id email:email callback:redeemRewardCallback];
        // else display AlertView to handle redemption
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Redeem" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Redeem", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[alertView textFieldAtIndex:0] setPlaceholder:@"E-mail"];
            
            [alertView show];
            [alertView release];
        }
        
    } else if ([title isEqualToString:@"Terms of Service"]) {
        [[[[UIAlertView alloc] initWithTitle:@"Terms of Service"
                                     message:reward.tos_text
                                    delegate:nil
                           cancelButtonTitle:nil
                           otherButtonTitles:@"Ok", nil] autorelease] show];
    }
}

@end
