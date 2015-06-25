//
//  LootsieAchievementBannerManager.m
//  Rev6
//
//  Created by Fabio Teles on 6/24/15.
//  Copyright (c) 2015 Itv. All rights reserved.
//

#import "LootsieAchievementBannerManager.h"
#import "LootsieAchievementBanner.h"
#import "Lootsie.h"
#import "cocos2d.h"

@interface LootsieAchievementBannerManager () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) void(^bannerAction)(void);
@property (strong, nonatomic) LootsieAchievementBanner *currentBanner;

@end

@implementation LootsieAchievementBannerManager

+ (instancetype)sharedManager {
    static LootsieAchievementBannerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LootsieAchievementBannerManager alloc] init];
    });
    return manager;
}

- (void)showBannerWithAchievementId:(NSString *)achievementId forInterval:(NSTimeInterval)interval action:(void(^)(void))action {
    if (self.currentBanner) return;
    
    LootsieAchievement *achievement = [[Lootsie sharedInstance] getAchievementForId:achievementId];
    if (!achievement) return;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBanner:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:tapGesture];
    
    CCScene *runningScene = [[CCDirector sharedDirector] runningScene];
    self.currentBanner = [LootsieAchievementBanner bannerWithAchievement:achievement];
    self.bannerAction = action;
    
    self.currentBanner.position = ccp(0, 320);
    [runningScene addChild:self.currentBanner z:666];
    
    __unsafe_unretained __typeof(self) unownedSelf = self;
    CCMoveBy *moveIn = [CCMoveBy actionWithDuration:0.7 position:ccp(0, -44)];
    CCMoveBy *moveOut = [CCMoveBy actionWithDuration:0.7 position:ccp(0, 44)];
    CCCallBlock *endAction = [CCCallBlock actionWithBlock:^{
        [unownedSelf.currentBanner removeFromParentAndCleanup:YES];
        [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:tapGesture];
        
        unownedSelf.currentBanner = nil;
        unownedSelf.bannerAction = nil;
    }];
    
    CCSequence *bannerSequence = [CCSequence actions:
                                  [CCEaseIn actionWithAction:moveIn rate:2.0],
                                  [CCDelayTime actionWithDuration:interval],
                                  [CCEaseOut actionWithAction:moveOut rate:2.0],
                                  endAction,
                                  nil];
    
    [self.currentBanner runAction:bannerSequence];
}

- (void)onTapBanner:(UITapGestureRecognizer *)gesture {
    if (self.currentBanner) {
        [self.currentBanner stopAllActions];
        
        __unsafe_unretained __typeof(self) unownedSelf = self;
        CCMoveBy *moveOut = [CCMoveBy actionWithDuration:0.7 position:ccp(0, 44)];
        CCCallBlock *endAction = [CCCallBlock actionWithBlock:^{
            [unownedSelf.currentBanner removeFromParentAndCleanup:YES];
            
            unownedSelf.currentBanner = nil;
            unownedSelf.bannerAction = nil;
        }];
        
        CCSequence *bannerSequence = [CCSequence actions:
                                      [CCEaseOut actionWithAction:moveOut rate:2.0],
                                      endAction,
                                      nil];
        
        
        [self.currentBanner runAction:bannerSequence];
    }
    
    // execute this anyways
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:gesture];
    if (self.bannerAction) self.bannerAction();
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (touchPoint.y <= 44.f) {
        return YES;
    }
    return NO;
}

@end
