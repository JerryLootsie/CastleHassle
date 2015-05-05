//
//  ImageURLsResponse.h
//  Lootsie
//
//  Created by Jerry Lootsie on 3/31/15.
//  Copyright (c) 2015 Lootsie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"
#import "RKObjectMapping.h"

@interface ImageURLsResponse : NSObject

@property (nonatomic, strong) NSString* DETAIL;
@property (nonatomic, strong) NSString* L;
@property (nonatomic, strong) NSString* M;
@property (nonatomic, strong) NSString* S;
@property (nonatomic, strong) NSString* XL;

+(RKObjectMapping*)defineRequestMapping;
@end
