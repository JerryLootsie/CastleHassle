//
//  LootsieAchievementBanner.h
//  Rev6
//
//  Created by Fabio Teles on 6/24/15.
//  Copyright (c) 2015 Itv. All rights reserved.
//

#import "CCLayer.h"

@class LootsieAchievement;

@interface LootsieAchievementBanner : CCLayerColor

+ (instancetype)bannerWithAchievement:(LootsieAchievement *)achievement;
- (id)initWithAchievement:(LootsieAchievement *)achievement;

@end
