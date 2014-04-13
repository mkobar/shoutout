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
#import <Rdio/Rdio.h>

@interface ViewController : UIViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, RdioDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UITextField *statusTextField;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;

@property (strong, nonatomic) PFObject * status;
@property (nonatomic, strong) NSMutableData *imageData;
@property (nonatomic, strong) Rdio *rdio;

@end
