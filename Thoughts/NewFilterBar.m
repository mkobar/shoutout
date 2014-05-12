//
//  NewFilterBar.m
//  Thoughts
//
//  Created by Zak Avila on 5/11/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "NewFilterBar.h"

@interface NewFilterBar ()

@property (nonatomic, strong) UIImageView *filterImage;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic) BOOL leftButtonSelected;
@property (nonatomic) BOOL rightButtonSelected;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *friendButton;
@property (nonatomic, strong) UIButton *meButton;

@end

@implementation NewFilterBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftButton = NO;
        self.rightButton = NO;
        self.filterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FilterNone"]];
        self.filterImage.frame = CGRectMake(self.frame.size.width/2-[UIImage imageNamed:@"FilterBoth"].size.width/2, 0.0f, [UIImage imageNamed:@"FilterBoth"].size.width, [UIImage imageNamed:@"FilterBoth"].size.height);
        [self addSubview:self.filterImage];
        
        self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-[UIImage imageNamed:@"FilterBoth"].size.width/2, 0.0f, [UIImage imageNamed:@"FilterBoth"].size.height, [UIImage imageNamed:@"FilterBoth"].size.height)];
        [self.leftButton addTarget:self action:@selector(sideButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftButton];
        
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-(self.frame.size.width/2-[UIImage imageNamed:@"FilterBoth"].size.width/2)-[UIImage imageNamed:@"FilterBoth"].size.height, 0.0f, [UIImage imageNamed:@"FilterBoth"].size.height, [UIImage imageNamed:@"FilterBoth"].size.height)];
        [self.rightButton addTarget:self action:@selector(sideButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightButton];
    }
    return self;
}

- (void)filterButtonClicked:(UIButton*)button
{
    
}

- (void)sideButtonPressed:(UIButton*)button
{
    if (button == self.leftButton) {
        self.leftButtonSelected = !self.leftButtonSelected;
    }
    else if (button == self.rightButton) {
        self.rightButtonSelected = !self.rightButtonSelected;
    }
    if (self.rightButtonSelected ) {
        if (self.leftButtonSelected)
            self.filterImage.image = [UIImage imageNamed:@"FilterBoth"];
        else
            self.filterImage.image = [UIImage imageNamed:@"FilterRight"];
    }
    else {
        if (self.leftButtonSelected)
            self.filterImage.image = [UIImage imageNamed:@"FilterLeft"];
        else
            self.filterImage.image = [UIImage imageNamed:@"FilterNone"];
    }
}

@end
