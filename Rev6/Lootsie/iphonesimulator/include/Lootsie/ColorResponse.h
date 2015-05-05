//
//  ColorResponse.h
//  Lootsie
//
//  Created by Jerry Lootsie on 3/31/15.
//  Copyright (c) 2015 Lootsie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectMapping.h"

@interface ColorResponse : NSObject

@property (nonatomic) NSInteger R;
@property (nonatomic) NSInteger G;
@property (nonatomic) NSInteger B;

+(RKObjectMapping*)defineRequestMapping;
@end
