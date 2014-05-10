//
//  FilterBar.m
//  Thoughts
//
//  Created by Zak Avila on 5/10/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "FilterBar.h"

@interface FilterBar ()
@property (nonatomic) TabsSelected tabsSelected;
@property (nonatomic, strong) UIButton *pinTab;
@property (nonatomic, strong) UIButton *shoutTab;
@end

@implementation FilterBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawTabs];
        [self drawButtons];
    }
    return self;
}

- (void)drawTabs
{
    CGFloat roundedRadius = self.frame.size.height/2;
    
    self.pinTab = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width/4, self.frame.size.height/2)];
    self.pinTab.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    [self.pinTab setTitle:@"P" forState:UIControlStateNormal];
    self.pinTab.titleLabel.textColor = [UIColor blackColor];
    [self.pinTab addTarget:self action:@selector(didSelectTab:) forControlEvents:UIControlEventTouchUpInside];
    CAShapeLayer *pinMaskLayer = [CAShapeLayer layer];
    pinMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.pinTab.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(roundedRadius, roundedRadius)].CGPath;
    self.pinTab.layer.mask = pinMaskLayer;
    [self addSubview:self.pinTab];
    
    self.shoutTab = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height/2, self.frame.size.width/4, self.frame.size.height/2)];
    self.shoutTab.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    [self.shoutTab setTitle:@"S" forState:UIControlStateNormal];
    self.shoutTab.titleLabel.textColor = [UIColor blackColor];
    [self.shoutTab addTarget:self action:@selector(didSelectTab:) forControlEvents:UIControlEventTouchUpInside];
    CAShapeLayer *shoutMaskLayer = [CAShapeLayer layer];
    shoutMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.shoutTab.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(roundedRadius, roundedRadius)].CGPath;
    self.shoutTab.layer.mask = shoutMaskLayer;
    [self addSubview:self.shoutTab];
}

- (void)drawButtons
{
    self.globalButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/4, 0.0f, self.frame.size.width/4, self.frame.size.height)];
    self.globalButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    [self.globalButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.globalButton];
    
    self.friendsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/4*2, 0.0f, self.frame.size.width/4, self.frame.size.height)];
    self.friendsButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    [self.friendsButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.friendsButton];
    
    self.meButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/4*3, 0.0f, self.frame.size.width/4, self.frame.size.height)];
    self.meButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    [self.meButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.meButton];
}

- (void)didSelectTab:(UIButton*)selectedTab
{
    if (selectedTab == self.pinTab) {
        [self pinTabSelected];
    }
    else if (selectedTab == self.shoutTab) {
        [self shoutTabSelected];
    }
    [self changeColorsForTabsSelected];
}

- (void)pinTabSelected
{
    switch (self.tabsSelected) {
        case None:
            self.tabsSelected = Pins;
            break;
        case Pins:
            self.tabsSelected = None;
            break;
        case Shouts:
            self.tabsSelected = Both;
            break;
        case Both:
            self.tabsSelected = Shouts;
            break;
        default:
            break;
    }
}

- (void)shoutTabSelected
{
    switch (self.tabsSelected) {
        case None:
            self.tabsSelected = Shouts;
            break;
        case Pins:
            self.tabsSelected = Both;
            break;
        case Shouts:
            self.tabsSelected = None;
            break;
        case Both:
            self.tabsSelected = Pins;
            break;
        default:
            break;
    }
}

- (void)changeColorsForTabsSelected
{
    switch (self.tabsSelected) {
        case None:
            self.pinTab.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
            self.shoutTab.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
            self.globalButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
            self.friendsButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
            self.meButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
            break;
        case Pins:
            self.pinTab.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.80f];
            self.shoutTab.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
            self.globalButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.80f];
            self.friendsButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.80f];
            self.meButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.80f];
            break;
        case Shouts:
            self.pinTab.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
            self.shoutTab.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.80f];
            self.globalButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.80f];
            self.friendsButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.80f];
            self.meButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
            break;
        case Both:
            self.shoutTab.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.80f];
            self.pinTab.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.80f];
            self.globalButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.80f];
            self.friendsButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.80f];
            self.meButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.80f];
            break;
        default:
            break;
    }
}

- (void)didSelectButton:(UIButton*)selectedButton
{
    [self.delegate filterBar:self didSelectButton:selectedButton withSelectedTabs:self.tabsSelected];
}

@end
