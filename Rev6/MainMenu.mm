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
		
        CGSize s = [[CCDirector sharedDirector] winSize];
        NSLog(@"MainMenu: winSize: %@", NSStringFromCGSize(s));
        // ipad retina winsize: 1024,768
        // iphone6 winsize: {480, 320}
        
        
		bg = sprite(@"background.jpg");
//        [bg setPosition:ccp(240, 160)];
        [bg setPosition:ccp(s.width/2, s.height/2)];
        [self addChild:bg z:0];
		
		CCSprite* logo = sprite(@"logo.png");

//        [logo setPosition:ccp(240, 245)];
        float innerBackgroundOffset = (s.height/2) - (320.0/2.0);
        //CGPoint logoPosition = ccp(s.width/2, (s.height * (245.0/320.0)));
        CGPoint logoPosition = ccp(s.width/2, innerBackgroundOffset + 245.0);
        NSLog(@"MainMenu: logoPosition: %@", NSStringFromCGPoint(logoPosition));
        [logo setPosition:logoPosition];
		[self addChild:logo z:0];
		
		CCSprite* navBack = sprite(@"splashNavBack.png");
//        [navBack setPosition:ccp(240, 62)];
//        [navBack setPosition:ccp(s.width/2, (s.height *(62.0/320.0)))];
        [navBack setPosition:ccp(s.width/2, (innerBackgroundOffset + 62.0))];
		[self addChild:navBack z:0];
		
		
		[CCMenuItemFont setFontSize:16];
		[CCMenuItemFont setFontName:@"arial"];
		
		// add the four buttons
		[self makeButtonWithString:@"Single Player" 
						atPosition:ccp(-70,-75) 
					  withSelector:@selector(singlePlayer:)];
		
		
		[self makeButtonWithString:@"Settings"
						atPosition:ccp(70,-121) 
					  withSelector:@selector(settings:)];
		
		[self makeButtonWithString:@"Campaign"
						atPosition:ccp(-70,-121)
					  withSelector:@selector(campaign:)];
		
		[self makeButtonWithString:@"How-to-play"
						atPosition:ccp(70,-75) 
					withSelector:@selector(howToPlay:)];
        
        [self makeButtonWithString:@"Lootsie-Rewards"
                        atPosition:ccp(0,-35)
                      withSelector:@selector(showLootsie:)];
        
	}
	return self;
}

-(void)showLootsie: (id)sender {
    
    NSLog(@"MainMenu: showLootsie");
    [[Lootsie sharedInstance] showRewardsPage];
    
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


@end
