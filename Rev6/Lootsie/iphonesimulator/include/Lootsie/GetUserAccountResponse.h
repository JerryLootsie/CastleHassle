//
//  GetUserAccountResponse.h
//  Lootsie
//
//  Created by Jerry Lootsie on 4/1/15.
//  Copyright (c) 2015 Lootsie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectMapping.h"

@interface GetUserAccountResponse : NSObject

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

+(RKObjectMapping*)defineRequestMapping;
@end
