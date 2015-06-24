//
//  MainMenu.m
//  Rev5
//
//  Created by Bryce Redd on 3/13/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import "MainMenu.h"
#import "MainScene.h"
#import "SinglePlayer.h"
#import "Settings.h"
#import "HowToPlay.h"
#import "MapScreen.h"
#import "Credits.h"
#import "BackButtonLayer.h"
#import "GameSettings.h"
#import "LootsieAchievementsScreen.h"
#import "LootsieRewardsScreen.h"
#import "Lootsie.h"

@implementation MainMenu

@synthesize bg;

static MainMenu * instance = nil;

+(MainMenu *) instance {
	if(instance == nil) {
		instance = [[MainMenu alloc] init];
	}
	
	return instance;
}

+(void) resetInstance {
    [instance release];
	instance = nil;
}

-(id) init {
	
    if ((self = [super init])) {
        [self addChild:[MainMenuLayer node] z:1 tag:MAIN_MENU_LAYER];

        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"background-music.caf"];
        
        if ([SimpleAudioEngine sharedEngine].willPlayBackgroundMusic) {
            [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1.0f;
        }
    
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music.caf"];

        [GameSettings instance];
		
    }
		
    return self;
}

@end

@implementation MainMenuLayer

-(id) init {
	
	if( (self=[super init])) {
		
		bg = sprite(@"background.jpg");
        [bg setPosition:ccp(240, 160)];
        [self addChild:bg z:0];
		
		CCSprite* logo = sprite(@"logo.png");

        [logo setPosition:ccp(240, 245)];
		[self addChild:logo z:0];
		
		CCSprite* navBack = sprite(@"splashNavBack2.png");
        [navBack setPosition:ccp(240, 40)];
		[self addChild:navBack z:0];
		
		
		[CCMenuItemFont setFontSize:16];
		[CCMenuItemFont setFontName:@"arial"];
		
		// add the six buttons
        
        [self iconMenuItemWithIconRect:CGRectMake(0.f, 0.f, 24.f, 24.f) atPosition:ccp(-115, -120) selector:@selector(singlePlayer:)];
        
        [self iconMenuItemWithIconRect:CGRectMake(24.f, 0.f, 24.f, 24.f) atPosition:ccp(-69, -120) selector:@selector(campaign:)];
        
        [self iconMenuItemWithIconRect:CGRectMake(48.f, 0.f, 24.f, 24.f) atPosition:ccp(-23, -120) selector:@selector(showAchievements:)];
        
        [self iconMenuItemWithIconRect:CGRectMake(72.f, 0.f, 24.f, 24.f) atPosition:ccp(23, -120) selector:@selector(showRewards:)];
        
        [self iconMenuItemWithIconRect:CGRectMake(96.f, 0.f, 24.f, 24.f) atPosition:ccp(69, -120) selector:@selector(settings:)];
        
        [self iconMenuItemWithIconRect:CGRectMake(120.f, 0.f, 24.f, 24.f) atPosition:ccp(113, -120) selector:@selector(howToPlay:)];
	}
	return self;
}


-(void)campaign: (id)sender {
	MainMenu* main = [MainMenu instance];
	[main removeChild:self cleanup:YES];
	CCSprite* blackBg = sprite(@"blackWall.png");
	[blackBg setPosition:ccp(240, 160)];
	[main addChild:blackBg z:1];
	[main addChild:[MapScreen node] z:2];
	[main addChild:[BackButtonLayer node] z:3];
}

-(void)singlePlayer: (id)sender {
	MainMenu* main = [MainMenu instance];
	[main removeChild:self cleanup:YES];
	[main addChild:[SinglePlayer node]];
}

-(void)settings: (id)sender {
	NSLog(@"settings");
	MainMenu* main = [MainMenu instance];
	[main removeChild:self cleanup:YES];
	[main addChild:[Settings node]];	
}

-(void)howToPlay: (id)sender {
	NSLog(@"how to play");
	MainMenu* main = [MainMenu instance];
	[main removeChild:self cleanup:YES];
	[main addChild:[HowToPlay node]];
}

-(void)credits: (id)sender {
	MainMenu* main = [MainMenu instance];
	[main removeChild:self cleanup:YES];
	[main addChild:[Credits node]];
}

- (void)showRewards: (id)sender {
    MainMenu* main = [MainMenu instance];
    [main removeChild:self cleanup:YES];
    [main addChild:[LootsieRewardsScreen node]];
}

- (void)showAchievements: (id)sender {
    MainMenu* main = [MainMenu instance];
    [main removeChild:self cleanup:YES];
    [main addChild:[LootsieAchievementsScreen node]];
}


@end
