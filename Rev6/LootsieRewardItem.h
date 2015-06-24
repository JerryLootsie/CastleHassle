//
//  LootsieRewardItem.h
//  Rev6
//
//  Created by Fabio Teles on 6/23/15.
//  Copyright (c) 2015 Itv. All rights reserved.
//

#import "CCLayer.h"

@class LootsieReward;

@interface LootsieRewardItem : CCLayerColor

@property (strong, nonatomic, readonly) LootsieReward *reward;

+ (instancetype)layerWithReward:(LootsieReward *)reward;
+ (instancetype)layerWithColor:(ccColor4B)color reward:(LootsieReward *)reward;
+ (instancetype)layerWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h reward:(LootsieReward *)reward;

- (id)initWithReward:(LootsieReward *)reward;
- (id)initWithColor:(ccColor4B)color reward:(LootsieReward *)reward;
- (id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h reward:(LootsieReward *)reward;

@end
