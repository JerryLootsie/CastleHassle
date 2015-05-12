//
//  AppDelegate.h
//  Rev6
//
//  Created by Bryce Redd on 1/11/12.
//  Copyright Itv 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lootsie.h"

@class RootViewController;

typedef enum playerStateTypes
{
    ANIM_OFF,
    ANIM_PLAYING,
    ANIM_STOPPED
} AnimationState;

@interface AppDelegate : NSObject <UIApplicationDelegate, LootsieDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    AnimationState animState;
}



@property (nonatomic, retain) UIWindow *window;

+ (NSString *) documentDir;

+(AppDelegate*) sharedInstance;
- (id) init;
-(UIViewController*) getRootViewController;
@end
