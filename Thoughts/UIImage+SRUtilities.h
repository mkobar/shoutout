//
//  UIImage+SRUtilities.h
//  SuperRdio
//
//  Created by Zak Avila on 1/30/14.
//  Copyright (c) 2014 Zak Avila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SRUtilities)

+ (UIImage*)currentContextImage:(UIView*)currentView;
+ (UIImage*)imageWithColor:(UIColor*)color andCGSize:(CGSize)size;
- (UIImage*)overlayWithColor:(UIColor*)color;
- (UIImage*)resizeToSize:(CGSize)size;
- (UIImage*)addRoundedCornersWithRadius:(CGFloat)radius;

@end
