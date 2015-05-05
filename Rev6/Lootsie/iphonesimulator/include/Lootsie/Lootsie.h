//
//  Lootsie.h
//  Lootsie
//
//  Created by Jerry Lootsie on 4/22/15.
//  Copyright (c) 2015 Lootsie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// the sole point of this class is to hide headers and other info from the developer, so there aren't conflicts
// (damn cocos2d)
// this is basically a pass through to LootsieEngine

// some simple types
// setRenderingMode
typedef enum LOOTSIE_RENDERING_MODE {
    landscape,
    portrait,
    portrait_as_landscape,
    landscape_as_portrait,
    automatic
} LOOTSIE_RENDERING_MODE;

// setLogLevel
typedef enum LOOTSIE_LOGGING_LEVEL {
    disabled,
    verbose
} LOOTSIE_LOGGING_LEVEL;

// setNotificationConfiguration
typedef enum LOOTSIE_NOTIFICATION_CONFIGURATION {
    notify_to_disabled,
    notify_to_rewardsPage,
    notify_to_achievementsPage,
    notify_to_aboutPage,
    notify_to_TOSPage,
    notify_to_webView,
    notify_to_customPage
} LOOTSIE_NOTIFICATION_CONFIGURATION;

typedef void(^ServiceCallback)(BOOL success, id result, NSString* errorMessage, NSInteger statusCode);
typedef void(^CompletionCallback)(BOOL finished);


@interface Lootsie : NSObject {
@public
    UIViewController* (^getControllerBlock)(void);
@private
    
}

+(Lootsie*) sharedInstance;
//- (id) init;
- (void) initWithAppKey: (NSString*) appKey;
- (void) initWithAppKeyCallback: (NSString*) appKey callback:(ServiceCallback) callback;

- (void) setLocation: (NSString*) locationStr;
- (NSString*) getGPSLocation;

- (void) achievementReachedWithId:(NSString*) achievementId;
- (void) achievementReachedWithIdLocation:(NSString*) achievementId location:(NSString*) location;
- (void) achievementReachedWithIdLocationCallback:(NSString*) achievementId location:(NSString*) location callback:(ServiceCallback) callback;

- (BOOL) getUserAchievements:(ServiceCallback) callback;
- (BOOL) getUserRewards:(ServiceCallback) callback;

- (void) redeemReward:(NSString*) rewardId email:(NSString*) email callback:(ServiceCallback) callback;

-(void) showRewardsPage;
-(void) showAchievementsPage;
-(void) showVersionInfoPage;
-(void) showTermsOfServicePage;

- (void) setLogLevel:(LOOTSIE_LOGGING_LEVEL) loggingLevel;
//- (void) logToGUI:(NSString*) tempStr;

//- (ServiceCallback) getInitCallback;
//- (ServiceCallback) getAchievementReachedCallback;
//- (ServiceCallback) getRedeemRewardCallback;

//- (AchievementResponse*) getAchievementForId:(NSString*) achievementId;
- (NSMutableArray*) getAchievements;
- (NSMutableArray*) getRewards;

//-(void) setSDKEnabled:(BOOL) inputStatus;
-(Boolean) getSDKEnabled;

//- (LootsieData*) getLootsieData;
//- (void) saveLootsieData;

- (void) setRenderingMode:(LOOTSIE_RENDERING_MODE) renderingMode;
//- (LOOTSIE_RENDERING_MODE) getRenderingMode;

- (void) setNotificationConfiguration:(LOOTSIE_NOTIFICATION_CONFIGURATION) notificationConfig;
//- (LOOTSIE_NOTIFICATION_CONFIGURATION) getNotificationConfiguration;

@end
