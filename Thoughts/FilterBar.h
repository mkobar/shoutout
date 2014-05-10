//
//  FilterBar.h
//  Thoughts
//
//  Created by Zak Avila on 5/10/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    None, Pins, Shouts, Both
}TabsSelected;

@class FilterBar;

@protocol FilterBarDelegate <NSObject>
- (void)filterBar:(FilterBar*)filterBar didSelectButton:(UIButton*)button withSelectedTabs:(TabsSelected)selectedTabs;
@end

@interface FilterBar : UIView

@property (nonatomic, strong) UIButton *globalButton;
@property (nonatomic, strong) UIButton *friendsButton;
@property (nonatomic, strong) UIButton *meButton;
@property id<FilterBarDelegate>  delegate;

@end
