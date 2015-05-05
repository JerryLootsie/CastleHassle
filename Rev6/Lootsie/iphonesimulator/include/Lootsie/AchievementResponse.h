//
//  AchievementResponse.h
//  Lootsie
//
//  Created by Jerry Lootsie on 3/31/15.
//  Copyright (c) 2015 Lootsie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectMapping.h"

@interface AchievementResponse : NSObject

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


+(RKObjectMapping*)defineRequestMapping;
@end
