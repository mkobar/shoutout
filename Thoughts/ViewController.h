//
//  ViewController.h
//  Thoughts
//
//  Created by Mayank Jain on 4/12/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UITextField *statusTextField;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;

@property (strong, nonatomic) PFObject * status;
@property (nonatomic, strong) NSMutableData *imageData;

@end
