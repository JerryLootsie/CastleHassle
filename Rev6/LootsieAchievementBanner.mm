//
//  LootsieAchievementBanner.m
//  Rev6
//
//  Created by Fabio Teles on 6/24/15.
//  Copyright (c) 2015 Itv. All rights reserved.
//

#import "LootsieAchievementBanner.h"
#import "Lootsie.h"
#import "cocos2d.h"

@implementation LootsieAchievementBanner

+ (instancetype)bannerWithAchievement:(LootsieAchievement *)achievement {
    return [[[self alloc] initWithAchievement:achievement] autorelease];
}

- (id)initWithAchievement:(LootsieAchievement *)achievement {
    if (self = [super initWithColor:ccc4(58, 180, 255, 204) width:480 height:44]) {
        NSDictionary *iconRects = @{
                                    @"applaunch": [NSValue valueWithCGRect:CGRectMake(0.f, 0.f, 45.f, 34.f)],
                                    @"castlehit": [NSValue valueWithCGRect:CGRectMake(0.f, 34.f, 45.f, 35.f)],
                                    @"winGame": [NSValue valueWithCGRect:CGRectMake(0.f, 69.f, 45.f, 31.f)],
                                    @"loseGame": [NSValue valueWithCGRect:CGRectMake(0.f, 100.f, 45.f, 36.f)]
                                    };
        CGRect iconRect = [[iconRects objectForKey:achievement.achievement_id] CGRectValue];
        // icon
        CCSprite *sprite = spriteWithRect(@"achievements.png", iconRect);
        sprite.position = ccp(32.f, 22.f);
        [self addChild:sprite z:0];
        
        // title
        CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:achievement.name fontName:@"Arial Rounded MT Bold" fontSize:18.f];
        titleLabel.anchorPoint = ccp(0.f, 0.5f);
        titleLabel.position = ccp(66.f, 27.f);
        [titleLabel setColor:ccc3(255, 255, 255)];
        [self addChild:titleLabel z:0];
        
        // description
        CCLabelTTF* descLabel = [CCLabelTTF labelWithString:achievement.achievment_description fontName:@"Arial" fontSize:10.f];
        descLabel.anchorPoint = ccp(0.f, 0.5f);
        descLabel.position = ccp(66.f, 13.f);
        [descLabel setColor:ccc3(255, 255, 255)];
        [self addChild:descLabel z:0];
        
        // points
        CCLabelTTF* pointsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%ld CP", (long)achievement.lp] dimensions:CGSizeZero alignment:NSTextAlignmentRight fontName:@"Arial Rounded MT Bold" fontSize:18.f];
        pointsLabel.anchorPoint = ccp(1.f, .5f);
        pointsLabel.position = ccp(self.contentSize.width - 18.f, 29.f);
        [pointsLabel setColor:ccc3(255, 255, 255)];
        [self addChild:pointsLabel z:0];
        
        // tap to redeem
        CCLabelTTF* tapToRedeem = [CCLabelTTF labelWithString:@"Tap to Redeem" dimensions:CGSizeZero alignment:NSTextAlignmentRight fontName:@"Arial Rounded MT Bold" fontSize:10.f];
        tapToRedeem.anchorPoint = ccp(1.f, 0.f);
        tapToRedeem.position = ccp(self.contentSize.width - 8.f, 8.f);
        [tapToRedeem setColor:ccc3(255, 255, 255)];
        [self addChild:tapToRedeem z:0];
        
        // line
        ccColor4B ribbonColor = ccc4(255, 255, 255, 255);
        CCRibbon *ribbon = [CCRibbon ribbonWithWidth:5 image:@"ribbon.png" length:10.0 color:ribbonColor fade:1.f];
        [self addChild:ribbon z:8];
        [ribbon addPointAt:ccp(tapToRedeem.position.x - tapToRedeem.contentSize.width, tapToRedeem.position.y - 2) width:2];
        [ribbon addPointAt:ccp(tapToRedeem.position.x, tapToRedeem.position.y - 2) width:2];
    }
    
    return self;
}

@end
