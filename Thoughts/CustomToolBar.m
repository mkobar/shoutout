//
//  CustomToolBar.m
//  Thoughts
//
//  Created by Zak Avila on 5/10/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "CustomToolBar.h"

@implementation CustomToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawButtons];
    }
    return self;
}

- (void)drawButtons
{
    CGFloat smallButtonWidth = self.frame.size.width/8.0f;
    self.messagesButton = [[UIButton alloc] initWithFrame:CGRectMake(smallButtonWidth*2, self.frame.size.height-smallButtonWidth-2.0f, smallButtonWidth, smallButtonWidth)];
    [self.messagesButton setImage:[UIImage imageNamed:@"Messages"] forState:UIControlStateNormal];
    [self.messagesButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.messagesButton];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(smallButtonWidth*3, self.frame.size.height-smallButtonWidth*2, smallButtonWidth*2, smallButtonWidth*2)];
    [self.addButton setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addButton];
    
    self.settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(smallButtonWidth*5, self.frame.size.height-smallButtonWidth-2.0f, smallButtonWidth, smallButtonWidth)];
    [self.settingsButton setImage:[UIImage imageNamed:@"Settings"] forState:UIControlStateNormal];
    [self.settingsButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.settingsButton];
    
    self.addShoutButton = [[UIButton alloc] initWithFrame:CGRectMake(smallButtonWidth*5/2-10.0f, 0.0f, smallButtonWidth, smallButtonWidth)];
    self.addShoutButton.hidden = YES;
    [self.addShoutButton setImage:[UIImage imageNamed:@"AddShout"] forState:UIControlStateNormal];
    [self addSubview:self.addShoutButton];
    
    self.addPinButton = [[UIButton alloc] initWithFrame:CGRectMake(smallButtonWidth*9/2+10.0f, 0.0f, smallButtonWidth, smallButtonWidth)];
    self.addPinButton.hidden = YES;
    [self.addPinButton setImage:[UIImage imageNamed:@"AddPin"] forState:UIControlStateNormal];
    [self addSubview:self.addPinButton];
}

- (void)didSelectButton:(UIButton*)button
{
    if (button == self.addButton) {
        if (button.tintColor == [UIColor blackColor]) {
            self.addShoutButton.hidden = NO;
            self.addPinButton.hidden = NO;
            self.addButton.tintColor = [UIColor blackColor];
        }
        else {
            self.addShoutButton.hidden = YES;
            self.addPinButton.hidden = YES;
            self.addButton.tintColor = [UIColor clearColor];
        }
    }
}

- (void)hideAddButtons
{
    self.addPinButton.hidden = YES;
    self.addShoutButton.hidden = YES;
}

@end
