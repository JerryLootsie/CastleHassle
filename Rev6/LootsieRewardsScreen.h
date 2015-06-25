//
//  LootsieRewardsScreen.h
//  Rev6
//
//  Created by Fabio Teles on 6/19/15.
//  Copyright (c) 2015 Itv. All rights reserved.
//

#import "BaseMenu.h"

@interface LootsieRewardsScreen : BaseMenu

@property (nonatomic) BOOL gameMode;
@property (strong, nonatomic) void (^closeBlock)(void);

+ (LootsieRewardsScreen *)instance;

@end
