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

// moved from LootsieEngine.h
@protocol LootsieDelegate <NSObject>
@optional
- (void) achievementReachedBarExpanded;
- (void) achievementReachedBarClosed;
@end


// see also Net/GetApp/AchievementResponse.h
// we want to avoid forcing the developer to have to include restkit header files because of conflicts
@interface LootsieAchievement : NSObject

// app achievement - from Get /app
@property (nonatomic, strong) NSString* achievment_description;
@property (nonatomic, strong) NSString* achievement_id;
@property (nonatomic) Boolean is_achieved;
@property (nonatomic) NSInteger lp;
@property (nonatomic, strong) NSString* name;
@property (nonatomic) Boolean repeatable;

// user achievement - from Get /user/achievements
// id
// date
@property (nonatomic, strong) NSString* date;
// lp

@end

// see also Net/GetUserAccount/GetUserAccountResponse.h
// we want to avoid forcing the developer to have to include restkit header files because of conflicts
@interface LootsieUserAccount : NSObject

@property (nonatomic, strong) NSString* photo_url;
@property (nonatomic) NSInteger total_lp;
@property (nonatomic) NSInteger zipcode;
@property (nonatomic) Boolean accepted_tos;
@property (nonatomic) NSArray* interest_groups;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* gender;
@property (nonatomic) Boolean lootsie_optin;
@property (nonatomic) NSInteger confirmed_age;
@property (nonatomic, strong) NSString* email;
@property (nonatomic) NSInteger home_zipcode;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) NSString* last_name;
@property (nonatomic, strong) NSString* first_name;
@property (nonatomic) Boolean is_guest;
@property (nonatomic, strong) NSString* birthdate;
@property (nonatomic) Boolean partner_optin;
@property (nonatomic, strong) NSString* city;

@end

// see also Net/GetApp/ImageURLsResponse.h
// we want to avoid forcing the developer to have to include restkit header files because of conflicts
@interface LootsieImageURLs : NSObject

@property (nonatomic, strong) NSString* DETAIL;
@property (nonatomic, strong) NSString* L;
@property (nonatomic, strong) NSString* M;
@property (nonatomic, strong) NSString* S;
@property (nonatomic, strong) NSString* XL;

@end

// see also Net/GetUserReward/GetUserRewardResponse.h RewardResponse.h
// we want to avoid forcing the developer to have to include restkit header files because of conflicts
@interface LootsieReward : NSObject

@property (nonatomic, strong) NSString* brand_name;
@property (nonatomic, strong) NSString* reward_description; // description
@property (nonatomic, strong) NSString* reward_id; // id
@property (nonatomic) NSArray* engagements; // EngagementsResponse
@property (nonatomic) LootsieImageURLs* image_urls;
@property (nonatomic) NSInteger is_limited_time;
@property (nonatomic) NSInteger is_new;
@property (nonatomic) NSInteger lp;
@property (nonatomic, strong) NSString* name;
@property (nonatomic) NSInteger redemptions_remaining;
@property (nonatomic, strong) NSString* text_to_share;
@property (nonatomic, strong) NSString* tos_text;
@property (nonatomic, strong) NSString* tos_url;

@end

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
- (LootsieUserAccount*) getUserAccount;

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

// moved from LootsieEngine.h
- (id<LootsieDelegate>) getDelegate;

// moved from LootsieEngine.h
// delegate for Lootsie
@property (assign, nonatomic) id<LootsieDelegate> delegate;

@end
