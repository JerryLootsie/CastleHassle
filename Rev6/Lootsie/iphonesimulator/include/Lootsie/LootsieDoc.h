//
//  LootsieDoc.h
//  Lootsie
//
//  Created by Jerry Lootsie on 4/1/15.
//  Copyright (c) 2015 Lootsie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LootsieData;

@interface LootsieDoc : NSObject {
    LootsieData *_data;
    NSString *_docPath;
}

@property (retain) LootsieData *data;
@property (copy) NSString *docPath;

- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (id)initWithTitle:(NSString*)title rating:(float)rating;
- (void)saveData;
//- (void)saveImages;
- (void)deleteDoc;

@end
