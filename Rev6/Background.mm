//
//  Ground.mm
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Background.h"

@implementation Background

- (id)initWithLeftImage:(NSString *)lImg 
			 rightImage:(NSString *)rImg
		 imageDimension:(CGPoint)dim
				  layer:(CCLayer*)parent 
				  index:(int)index 
		 parallaxFactor:(float)pf {
	
	if( (self=[super init])) {
		acceptsTouches = NO;
		acceptsDamage = NO;
		
		parallaxFactor = pf;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
        float innerBackgroundHeightOffset = (screenSize.height/2) - (320.0/2.0);
        float innerBackgroundWidthOffset = (screenSize.width/2) - (480.0/2.0);
        float scaleFactor = screenSize.width/320.0;
        
        // imageA left = 208.5
        // imageA right = 208.5 + 607 = 815.5
        // imageB left = 814.5
        // imageB right = 814.5 + 607 = 1421.5
        // (exceeds boundary at 1024) 1024 - 1421.5 = 397.5
        
        
        
		// setup the left sprite
		self.imageA = spriteWithRect(lImg, CGRectMake(0,0,dim.x,dim.y));
        //self.imageA.position = ccp(-1*dim.x/2+screenSize.width/2, dim.y/2);
        self.imageA.position = ccp(-1*dim.x/2+screenSize.width/2, innerBackgroundHeightOffset + dim.y/2);
        self.imageA.anchorPoint = ccp(0,.5);
		[parent addChild:self.imageA z:index];
    
        NSLog(@"Background imageA: position: %@", NSStringFromCGPoint(self.imageA.position));
        
		 
		// setup the right sprite
		self.imageB = spriteWithRect(rImg, CGRectMake(0,0,dim.x,dim.y));
		//self.imageB.position = ccp(dim.x/2+screenSize.width/2-1, dim.y/2);
        self.imageB.position = ccp(dim.x/2+screenSize.width/2-1, innerBackgroundHeightOffset + dim.y/2);
        self.imageB.anchorPoint = ccp(0,.5);
        [parent addChild:self.imageB z:index];
        
        NSLog(@"Background imageB: position: %@", NSStringFromCGPoint(self.imageB.position));
        
        // background was originally created to only use 2 images, not 3!
        // retina needs 3 images
        // backgrounds are 608x320
        // how many tiles for retina? 1024/608 = 1.68 (so it needs to show on the right AND left!)
        // how manhy tiles for iphone6? 480/608 = .7 (so it can show on the right or left)lImg.
        // dim.x is the image width
        // C|B|A or rImg|lImg|rImg
        if (screenSize.width > dim.x) {
            // need a third image!
            self.imageC = spriteWithRect(rImg, CGRectMake(0,0,dim.x,dim.y));
            self.imageC.position = ccp((-1.5*dim.x)+screenSize.width/2-1, innerBackgroundHeightOffset + dim.y/2);
            self.imageC.anchorPoint = ccp(0,.5);
            [parent addChild:self.imageC z:index];
            
        }
        
	}
	
	return self;
}

@end
