//
//  AddShoutWindow.h
//  Thoughts
//
//  Created by Zak Avila on 5/11/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddShoutWindow;

@protocol AddShoutWindowDelegate <NSObject>
- (void)addShoutWindow:(AddShoutWindow*)addShoutWindow didPressButton:(UIButton*)button;
@end

@interface AddShoutWindow : UIView <UITextViewDelegate>

@property (nonatomic, strong) UIButton *xButton;
@property (nonatomic, strong) UITextView *shoutContent;
@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) UIButton *postButton;
@property id<AddShoutWindowDelegate> delegate;

@end
