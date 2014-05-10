//
//  CustomToolBar.h
//  Thoughts
//
//  Created by Zak Avila on 5/10/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomToolBar;

@protocol CustomToolBarDelegate <NSObject>
- (void)didSelectButton:(UIButton*)button;
@end

@interface CustomToolBar : UIView

@property (nonatomic, strong) UIButton *messagesButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *addPinButton;
@property (nonatomic, strong) UIButton *addShoutButton;
@property (nonatomic, strong) UIButton *settingsButton;

- (void)hideAddButtons;

@end
