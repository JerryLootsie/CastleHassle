//
//  HowToPlay.h
//  Rev5
//
//  Created by Dave Durazzani on 4/1/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseMenu.h"


@interface H2Pscreen2 : BaseMenu {
    // fixes for retina
    CGSize s;
    float innerBackgroundHeightOffset;
    float innerBackgroundWidthOffset;
    float scaleFactor;
}

+(H2Pscreen2 *) instance;

@end
