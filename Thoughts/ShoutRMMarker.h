//
//  ShoutRMMarker.h
//  Thoughts
//
//  Created by Zak Avila on 5/10/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "MapBox.h"
#import "ButtonRMMarker.h"

@class ShoutRMMarker;
@class RMAnnotation;

@protocol ShoutRMMarker <NSObject>
- (void)shoutRMMarker:(ShoutRMMarker*)marker didPressButtonWithName:(NSString*)buttonName;
@end

@interface ShoutRMMarker : ButtonRMMarker

- (id)initShoutWithUIImage:(UIImage*)image andAnnotation:(RMAnnotation*)markerAnnotation;
- (void)didPressButtonWithName:(NSString*)name;

@end
