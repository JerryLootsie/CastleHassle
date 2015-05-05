//
//  LootsieData.h
//  Lootsie
//
//  Created by Jerry Lootsie on 4/1/15.
//  Copyright (c) 2015 Lootsie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetAppResponse.h"
#import "RewardResponse.h"
#import "GetUserAccountResponse.h"

@interface LootsieData : NSObject <NSCoding> {
    NSString *_title;
    float _rating;

    NSString *_apiSessionToken;
    NSString *_userSessionToken;

    int _beginTimestamp;
    int _endTimestamp;
    
    GetAppResponse *_app;
    NSArray* _rewards;
    GetUserAccountResponse *_user;
}

@property (copy) NSString *title;
@property  float rating;

@property (copy) NSString *apiSessionToken;
@property (copy) NSString *userSessionToken;

@property int beginTimestamp;
@property int endTimestamp;

@property GetAppResponse *app;
@property NSArray *rewards;
@property GetUserAccountResponse *user;

- (id)initWithTitle:(NSString*)title rating:(float)rating;

@end
