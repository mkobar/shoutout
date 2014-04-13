//
//  MapViewController.h
//  Thoughts
//
//  Created by Mayank Jain on 4/12/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <Mapbox/Mapbox.h>
#import <MessageUI/MessageUI.h>
#import <Firebase/Firebase.h>

@interface MapViewController : UIViewController<GMSMapViewDelegate, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate, RMMapViewDelegate, MFMessageComposeViewControllerDelegate, RDAPIRequestDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *map;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIView *slidingView;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UITextView *statusTextField;
@property (strong, nonatomic) IBOutlet UISwitch *privacyToggle;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)saveButtonPressed:(id)sender;
@property (strong, nonatomic) NSMutableArray * markerArray;
@property (strong, nonatomic) NSMutableArray * statusArray;
@property (strong, nonatomic) NSMutableDictionary * markerDictionary;

@property (assign, nonatomic) BOOL shelf;

@property (strong, nonatomic) Firebase* shoutoutRoot;
@property (strong, nonatomic) Firebase* shoutoutRootStatus;
@property (strong, nonatomic) Firebase* shoutoutRootPrivacy;

@property (strong, nonatomic) Rdio *rdio;
- (IBAction)shoutOutButtonPressed:(id)sender;

-(void)locationDidUpdate:(NSNotification *) notification;

@end
