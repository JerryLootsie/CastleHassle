//
//  LootsieDatabase.h
//  Lootsie
//
//  Created by Jerry Lootsie on 4/1/15.
//  Copyright (c) 2015 Lootsie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LootsieDoc.h"
#import "LootsieData.h"

@interface LootsieDatabase : NSObject <NSCoding> {
//    NSString *_title;
//    float _rating;
    LootsieDoc *_doc;
    LootsieData *_data;
}


+ (NSMutableArray *)loadLootsieDocs;
+ (NSString *)nextLootsieDocPath;
- (LootsieDoc *)loadLootsieDoc;
- (LootsieDoc *)loadOrCreateLootsieDoc;
- (LootsieData *)loadLootsieData;
- (LootsieData *)loadOrCreateLootsieData;
- (void) saveLootsieDoc;
@end
