//
//  BaseMenuy.m
//  Rev5
//
//  Created by Bryce Redd on 3/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseMenu.h"

@implementation BaseMenu

-(id) init {

	if( (self = [super init])) {
	}
	
	return self;
	
}

-(CCMenuItemSprite*)makeButtonWithString:(NSString*)s atPosition:(CGPoint)p withSelector:(SEL)selector {
	[CCMenuItemFont setFontSize:16];
    
    CGRect buttonFrame = CGRectMake(0, 38, 124, 38);
    
    CCSprite* button = spriteWithRect(@"stdButtons.png", buttonFrame);
    CCSprite* selectedButton = spriteWithRect(@"stdButtonsPressed.png", buttonFrame);
    
    CCMenuItemSprite* menuItem = [CCMenuItemSprite itemFromNormalSprite:button 
													selectedSprite:selectedButton 
															target:self 
														  selector:selector];
	
	menuItem.position = p;
    
    
	CCLabelTTF* label = [CCLabelTTF labelWithString:s fontName:@"arial" fontSize:16.f];
    label.color = ccc3(255, 255, 255);
    label.position = ccp(buttonFrame.size.width / 2.f, buttonFrame.size.height / 2.f);
    
    [menuItem addChild:label];
	
    CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
    menu.position = ccp(240, 160);
	[self addChild:menu z:6];
    
    return menuItem;
}

-(CCMenuItemSprite*)makeButtonFromRect:(CGRect)rect atPosition:(CGPoint)p withSelector:(SEL)selector {
	
    CCSprite* button = spriteWithRect(@"stdButtons.png", rect);
    CCSprite* selectedButton = spriteWithRect(@"stdButtonsPressed.png", rect);
	
	CCMenuItemSprite* menuItem = [CCMenuItemSprite itemFromNormalSprite:button 
													selectedSprite:selectedButton 
															target:self 
														  selector:selector];
	menuItem.position = p;
	button.position = ccpAdd(ccp(240.0,160.0), p);
	selectedButton.position = ccpAdd(ccp(240.0,160.0), p);
	
    [self addChild:button z:2];
	[self addChild:selectedButton z:2];
	
	CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
    menu.position = ccp(240, 160);
	[self addChild:menu z:6];
	
	return menuItem;
}

- (CCMenuItemSprite *)iconMenuItemWithIconRect:(CGRect)iconRect atPosition:(CGPoint)p selector:(SEL)selector {
    
    CGRect buttonFrame = CGRectMake(0.f, 116.f, 38.f, 38.f);
    CCSprite* button = spriteWithRect(@"stdButtons.png", buttonFrame);
    CCSprite* selectedButton = spriteWithRect(@"stdButtonsPressed.png", buttonFrame);
    
    CCMenuItemSprite* menuItem = [CCMenuItemSprite itemFromNormalSprite:button
                                                         selectedSprite:selectedButton
                                                                 target:self
                                                               selector:selector];
    
    menuItem.position = p;
    
    CCSprite *icon = spriteWithRect(@"menu-icons.png", iconRect);
    icon.position = ccp(buttonFrame.size.width / 2.f, buttonFrame.size.height / 2.f);
    [menuItem addChild:icon];
    
    CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
    menu.position = ccp(240, 160);
    [self addChild:menu z:6];
    
    return menuItem;
}

-(void)toggled:(id)sender {}

@end
