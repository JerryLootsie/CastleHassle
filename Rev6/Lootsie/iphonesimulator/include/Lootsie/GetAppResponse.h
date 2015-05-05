//
//  GetAppResponse.h
//  Lootsie
//
//  Created by Jerry Lootsie on 3/31/15.
//  Copyright (c) 2015 Lootsie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectMapping.h"

#import "AchievementResponse.h"
#import "ColorResponse.h"
#import "ImageURLsResponse.h"

@interface GetAppResponse : NSObject

@property (nonatomic) NSInteger achievable_lp;
@property (nonatomic) NSArray* achievements;  // AchievementResponse
@property (nonatomic) ColorResponse* background_color;
@property (nonatomic) NSNumber* duration;
@property (nonatomic) NSArray* engagements; // EngagementsResponse
@property (nonatomic) NSArray* genres;// GenresResponse
@property (nonatomic, strong) NSString* hook_type;
@property (nonatomic, strong) NSString* app_id; // id
@property (nonatomic) ImageURLsResponse* image_urls;
@property (nonatomic) NSInteger more_apps;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* notification;
@property (nonatomic, strong) NSString* orientation;
@property (nonatomic, strong) NSString* pos_x;
@property (nonatomic, strong) NSString* pos_y;
@property (nonatomic) ColorResponse* text_color;
@property (nonatomic) NSInteger total_lp_earned;


+(RKObjectMapping*)defineRequestMapping;
@end
