//
//  ShoutRMMarker.m
//  Thoughts
//
//  Created by Zak Avila on 5/10/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "ShoutRMMarker.h"

@interface ShoutRMMarker ()
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) CATextLayer *textLayer;
@property (nonatomic, strong) CALayer *emailLayer;
@property (nonatomic, strong) CALayer *locationLayer;
@property (nonatomic, strong) CALayer *friendLayer;
@property (nonatomic, strong) CALayer *ellipsesLayer;
@property (nonatomic, strong) CALayer *farEllipsesLayer;
@property (nonatomic, strong) CALayer *farEmailLayer;
@property (nonatomic, strong) CALayer *farShareLayer;
@property (nonatomic, strong) CALayer *farLocationLayer;
@property (nonatomic, strong) CALayer *farFriendLayer;
@property (nonatomic, strong) CALayer *farVerticalEllipses;
@property (nonatomic, strong) NSString *shout;
@end

#define ANCHOR_POINT_X 0.0f
#define ANCHOR_POINT_Y 0.5f

@implementation ShoutRMMarker

- (id)initShoutWithUIImage:(UIImage *)image andAnnotation:(RMAnnotation *)markerAnnotation
{
    NSString *imageToUse = @"ShoutBubble";
    if (markerAnnotation.title) {
        imageToUse = @"ShoutBubbleMore";
    }
    self = [super initWithUIImage:[UIImage imageNamed:imageToUse] anchorPoint:CGPointMake(ANCHOR_POINT_X, ANCHOR_POINT_Y)];
    if (self) {
        if (markerAnnotation.title)
            self.shout = [[NSString alloc] initWithString:markerAnnotation.title];
        
        self.imageLayer = [CALayer layer];
        self.imageLayer.name = @"profile";
        self.imageLayer.frame = CGRectMake(2.5f, 3.0f, 50.0f, 50.0f);
        self.imageLayer.cornerRadius = 25.0f;
        self.imageLayer.contents = (id)image.CGImage;
        self.imageLayer.masksToBounds = YES;
        [self addSublayer:self.imageLayer];
        
        self.textLayer = [[CATextLayer alloc] init];
        self.textLayer.frame = CGRectMake(58.0f, 3.0f, 72.0f, 50.0f);
        self.textLayer.string = self.shout;
        self.textLayer.fontSize = 12.6f;
        self.textLayer.wrapped = YES;
        self.textLayer.foregroundColor = [UIColor blackColor].CGColor;
        self.textLayer.hidden = YES;
        [self addSublayer:self.textLayer];
        
        self.emailLayer = [CALayer layer];
        self.emailLayer.name = @"email";
        self.emailLayer.frame = CGRectMake(50.5f, 0.0f, 25.0f, 25.0f);
        self.emailLayer.hidden = YES;
        [self addSublayer:self.emailLayer];
        
        self.locationLayer = [CALayer layer];
        self.locationLayer.name = @"location";
        self.locationLayer.frame = CGRectMake(60.0f, 27.0f, 25.0f, 25.0f);
        self.locationLayer.hidden = YES;
        [self addSublayer:self.locationLayer];
        
        self.friendLayer = [CALayer layer];
        self.friendLayer.name = @"friend";
        self.friendLayer.frame = CGRectMake(50.5f, 55.0f, 25.0f, 25.0f);
        self.friendLayer.hidden = YES;
        [self addSublayer:self.friendLayer];
        
        self.ellipsesLayer = [CALayer layer];
        self.ellipsesLayer.name = @"ellipses";
        self.ellipsesLayer.frame = CGRectMake(50.0f, 1.5f, 25.0f, 25.0f);
        self.ellipsesLayer.hidden = YES;
        [self addSublayer:self.ellipsesLayer];
        
        self.farEllipsesLayer = [CALayer layer];
        self.farEllipsesLayer.name = @"farEllipses";
        self.farEllipsesLayer.frame = CGRectMake(138.0f, 1.5f, 25.0f, 25.0f);
        self.farEllipsesLayer.hidden = YES;
        [self addSublayer:self.farEllipsesLayer];
        
        self.farEmailLayer = [CALayer layer];
        self.farEmailLayer.name = @"email";
        self.farEmailLayer.frame = CGRectMake(125.0f, 0.0f, 25.0f, 25.0f);
        self.farEmailLayer.hidden = YES;
        [self addSublayer:self.farEmailLayer];
        
        self.farShareLayer = [CALayer layer];
        self.farShareLayer.name = @"share";
        self.farShareLayer.frame = CGRectMake(155.0f, 0.0f, 25.0f, 25.0f);
        self.farShareLayer.hidden = YES;
        [self addSublayer:self.farShareLayer];
        
        self.farLocationLayer = [CALayer layer];
        self.farLocationLayer.name = @"location";
        self.farLocationLayer.frame = CGRectMake(168.0f, 30.0f, 25.0f, 25.0f);
        self.farLocationLayer.hidden = YES;
        [self addSublayer:self.farLocationLayer];
        
        self.farFriendLayer = [CALayer layer];
        self.farFriendLayer.name = @"friend";
        self.farFriendLayer.frame = CGRectMake(152.0f, 57.0f, 25.0f, 25.0f);
        self.farFriendLayer.hidden = YES;
        [self addSublayer:self.farFriendLayer];
        
        self.farVerticalEllipses = [CALayer layer];
        self.farVerticalEllipses.name = @"verticalEllipses";
        self.farVerticalEllipses.frame = CGRectMake(137.0f, 29.0f, 25.0f, 25.0f);
        self.farVerticalEllipses.hidden = YES;
        [self addSublayer:self.farVerticalEllipses];
    }
    return self;
}

- (void)didPressButtonWithName:(NSString *)name
{
    if ([name isEqualToString:@"profile"]) {
        if (self.shout)
            [self toggleShout];
        else
            [self toggleIcons];
    }
    else if ([name isEqualToString:@"email"]) {
        
    }
    else if ([name isEqualToString:@"share"]) {
        
    }
    else if ([name isEqualToString:@"location"]) {
        
    }
    else if ([name isEqualToString:@"friend"]) {
        
    }
    else if ([name isEqualToString:@"ellipses"]) {
        [self toggleShout];
    }
    else if ([name isEqualToString:@"farEllipses"]) {
        [self showIconsWithShout];
    }
    else if ([name isEqualToString:@"verticalEllipses"]) {
        [self hideIconsWithShout];
    }
}

- (void)toggleShout
{
    if (self.farEllipsesLayer.hidden)
        [self showShout];
    else
        [self hideShout];
}

- (void)showShout
{
    [super replaceUIImage:[UIImage imageNamed:@"ShoutBubbleText"] anchorPoint:CGPointMake(ANCHOR_POINT_X, ANCHOR_POINT_Y)];
    self.imageLayer.frame = CGRectMake(self.imageLayer.frame.origin.x, 3.0f, self.imageLayer.frame.size.width, self.imageLayer.frame.size.height);
    self.farEllipsesLayer.hidden = NO;
    self.farVerticalEllipses.hidden = YES;
    self.textLayer.hidden = NO;
    self.textLayer.frame = CGRectMake(self.textLayer.frame.origin.x, 3.0f, self.textLayer.frame.size.width, self.textLayer.frame.size.height);
}

- (void)hideShout
{
    [super replaceUIImage:[UIImage imageNamed:@"ShoutBubbleMore"] anchorPoint:CGPointMake(ANCHOR_POINT_X, ANCHOR_POINT_Y)];
    self.imageLayer.frame = CGRectMake(self.imageLayer.frame.origin.x, 3.0f, self.imageLayer.frame.size.width, self.imageLayer.frame.size.height);
    self.farEllipsesLayer.hidden = YES;
    self.farVerticalEllipses.hidden = YES;
    self.textLayer.hidden = YES;
    self.textLayer.frame = CGRectMake(self.textLayer.frame.origin.x, 3.0f, self.textLayer.frame.size.width, self.textLayer.frame.size.height);
}

- (void)toggleIcons
{
    if (self.shout && self.imageLayer.frame.origin.y == 30.0f)
        [self hideIconsWithShout];
    else if (self.shout)
        [self showIconsWithShout];
    else if (!self.shout && self.imageLayer.frame.origin.y == 15.0f)
        [self hideIconsWithoutShout];
    else if (!self.shout)
        [self showIconsWithoutShout];
}

- (void)showIconsWithShout
{
    [super replaceUIImage:[UIImage imageNamed:@"ShoutBubbleAll"] anchorPoint:CGPointMake(ANCHOR_POINT_X, ANCHOR_POINT_Y)];
    self.imageLayer.frame = CGRectMake(self.imageLayer.frame.origin.x, 30.0f, self.imageLayer.frame.size.width, self.imageLayer.frame.size.height);
    self.farVerticalEllipses.hidden = NO;
    self.textLayer.frame = CGRectMake(self.textLayer.frame.origin.x, 30.0f, self.textLayer.frame.size.width, self.textLayer.frame.size.height);
}

- (void)hideIconsWithShout
{
    [super replaceUIImage:[UIImage imageNamed:@"ShoutBubbleText"] anchorPoint:CGPointMake(ANCHOR_POINT_X, ANCHOR_POINT_Y)];
    self.imageLayer.frame = CGRectMake(self.imageLayer.frame.origin.x, 3.0f, self.imageLayer.frame.size.width, self.imageLayer.frame.size.height);
    self.farVerticalEllipses.hidden = YES;
    self.textLayer.frame = CGRectMake(self.textLayer.frame.origin.x, 3.0f, self.textLayer.frame.size.width, self.textLayer.frame.size.height);
}

- (void)showIconsWithoutShout
{
    [super replaceUIImage:[UIImage imageNamed:@"ShoutBubbleIcons"] anchorPoint:CGPointMake(ANCHOR_POINT_X, ANCHOR_POINT_Y)];
    self.imageLayer.frame = CGRectMake(self.imageLayer.frame.origin.x, 15.0f, self.imageLayer.frame.size.width, self.imageLayer.frame.size.height);
    self.emailLayer.hidden = NO;
    self.locationLayer.hidden = NO;
    self.friendLayer.hidden = NO;
}

- (void)hideIconsWithoutShout
{
    [super replaceUIImage:[UIImage imageNamed:@"ShoutBubble"] anchorPoint:CGPointMake(ANCHOR_POINT_X, ANCHOR_POINT_Y)];
    self.imageLayer.frame = CGRectMake(self.imageLayer.frame.origin.x, 3.0f, self.imageLayer.frame.size.width, self.imageLayer.frame.size.height);
    self.emailLayer.hidden = YES;
    self.locationLayer.hidden = YES;
    self.friendLayer.hidden = YES;
}

@end
