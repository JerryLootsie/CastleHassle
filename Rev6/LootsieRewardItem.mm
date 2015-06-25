//
//  LootsieRewardItem.m
//  Rev6
//
//  Created by Fabio Teles on 6/23/15.
//  Copyright (c) 2015 Itv. All rights reserved.
//

#import "LootsieRewardItem.h"
#import "Lootsie.h"
#import "cocos2d.h"

static const CGFloat _headerHeight = 30.f;

@interface LootsieRewardItem ()

@property (strong, nonatomic) CCLabelTTF *titleLabel;
@property (strong, nonatomic) CCLabelTTF *pointsLabel;
@property (strong, nonatomic) CCSprite *imageView;

@end

@implementation LootsieRewardItem

@synthesize reward = _reward;

+ (instancetype)layerWithReward:(LootsieReward *)reward {
    return [[[self alloc] initWithReward:reward] autorelease];
}

+ (instancetype)layerWithColor:(ccColor4B)color reward:(LootsieReward *)reward {
    return [[[self alloc] initWithColor:color reward:reward] autorelease];
}

+ (instancetype)layerWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h reward:(LootsieReward *)reward {
    return [[[self alloc] initWithColor:color width:w height:h reward:reward] autorelease];
}

- (id)initWithReward:(LootsieReward *)reward {
    if (self = [super init]) {
        _reward = reward;
        [self createSubviews];
    }
    return self;
}

- (id)initWithColor:(ccColor4B)color reward:(LootsieReward *)reward {
    if (self = [super initWithColor:color]) {
        _reward = reward;
        [self createSubviews];
    }
    return self;
}

- (id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h reward:(LootsieReward *)reward {
    if (self = [super initWithColor:color width:w height:h]) {
        _reward = reward;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.titleLabel = [CCLabelTTF labelWithString:self.reward.name fontName:@"Arial" fontSize:13.f];
    [self.titleLabel setColor:ccc3(15, 147, 222)];
    self.titleLabel.anchorPoint = ccp(0, .5);
    self.titleLabel.position = ccp(8, self.contentSize.height - _headerHeight * 0.5f);
    [self addChild:self.titleLabel z:1];
    
    CCSprite *cloud = [CCSprite spriteWithFile:@"rewards_cost_cloud.png"];
    cloud.position = ccp(self.contentSize.width - 30.f, self.contentSize.height - _headerHeight * 0.4f);
    [self addChild:cloud z:2];
    
    self.pointsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%lu CP", (long)self.reward.lp] fontName:@"Arial-BoldMT" fontSize:14.f];
    [self.pointsLabel setColor:ccc3(15, 147, 222)];
    self.pointsLabel.anchorPoint = ccp(1, .5);
    self.pointsLabel.position = ccp(self.contentSize.width - 8.f, self.contentSize.height - _headerHeight * 0.5f);
    [self addChild:self.pointsLabel z:3];
    
    [self loadRewardImage:self.reward.image_urls.M];
}

- (void)displayImage:(UIImage *)image {
    NSString *key = [NSString stringWithFormat:@"reward_image_%@", self.reward.reward_id];
    if (nil == self.imageView) {
        self.imageView = [CCSprite spriteWithCGImage:image.CGImage key:key];
        self.imageView.position = ccp(self.contentSize.width * 0.5f, self.contentSize.height * 0.5f - _headerHeight * 0.5f);
        [self addChild:self.imageView z:0];
    } else {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addCGImage:image.CGImage forKey:key];
        [self.imageView setTexture:texture];
        [self.imageView setTextureRect:CGRectMake(0, 0, texture.contentSize.width, texture.contentSize.height)];
    }
    CGSize imageContentSize = CGSizeMake(self.contentSize.width, self.contentSize.height - _headerHeight);
    self.imageView.scale = MIN(imageContentSize.width / self.imageView.contentSize.width, imageContentSize.height / self.imageView.contentSize.height);
}

- (void)loadRewardImage:(NSString *)path {
    // async load image
    NSString *thumbnailUrl = path;
    
    __unsafe_unretained __typeof(self) unownedSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbnailUrl]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [unownedSelf displayImage:[UIImage imageWithData:data]];
        });
    });
}

@end
