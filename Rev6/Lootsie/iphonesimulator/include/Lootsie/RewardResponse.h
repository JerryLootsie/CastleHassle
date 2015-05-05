//
//  RewardResponse.h
//  Lootsie
//
//  Created by Jerry Lootsie on 3/31/15.
//  Copyright (c) 2015 Lootsie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageURLsResponse.h"

@interface RewardResponse : NSObject

@property (nonatomic, strong) NSString* brand_name;
@property (nonatomic, strong) NSString* reward_description; // description
@property (nonatomic, strong) NSString* reward_id; // id
@property (nonatomic) NSArray* engagements; // EngagementsResponse
@property (nonatomic) ImageURLsResponse* image_urls;
@property (nonatomic) NSInteger is_limited_time;
@property (nonatomic) NSInteger is_new;
@property (nonatomic) NSInteger lp;
@property (nonatomic, strong) NSString* name;
@property (nonatomic) NSInteger redemptions_remaining;
@property (nonatomic, strong) NSString* text_to_share;
@property (nonatomic, strong) NSString* tos_text;
@property (nonatomic, strong) NSString* tos_url;

+(RKObjectMapping*)defineRequestMapping;
@end
