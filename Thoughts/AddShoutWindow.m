//
//  AddShoutWindow.m
//  Thoughts
//
//  Created by Zak Avila on 5/11/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "AddShoutWindow.h"

@interface AddShoutWindow ()

@property (nonatomic, strong) UIImageView *backgroundView;

@end

@implementation AddShoutWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AddShoutWindow"]];
    [self addSubview:self.backgroundView];
    self.xButton = [[UIButton alloc] initWithFrame:CGRectMake(215.0f, 0.0f, 25.0f, 25.0f)];
    [self.xButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.xButton];
    self.optionsButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 120.0f, 100.0f, 30.0f)];
    [self.optionsButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.optionsButton];
    self.postButton = [[UIButton alloc] initWithFrame:CGRectMake(140.0f, 120.0f, 100.0f, 30.0f)];
    [self.postButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.postButton];
    self.shoutContent = [[UITextView alloc] initWithFrame:CGRectMake(95.0f, 35.0f, 130.0f, 80.0f)];
    self.shoutContent.font = [UIFont systemFontOfSize:18.0f];
    self.shoutContent.backgroundColor = [UIColor clearColor];
    self.shoutContent.delegate = self;
    [self addSubview:self.shoutContent];
}

- (void)didPressButton:(UIButton*)button
{
    if (button == self.optionsButton) {
        
    }
    else {
        [self.delegate addShoutWindow:self didPressButton:button];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 30)
        textView.text = [textView.text substringToIndex:30];
}

@end
