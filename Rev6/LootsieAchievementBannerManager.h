//
//  LootsieAchievementBannerManager.h
//  Rev6
//
//  Created by Fabio Teles on 6/24/15.
//  Copyright (c) 2015 Itv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LootsieAchievementBannerManager : NSObject

+ (instancetype)sharedManager;
- (void)showBannerWithAchievementId:(NSString *)achievementId forInterval:(NSTimeInterval)interval action:(void(^)(void))action;

@end
