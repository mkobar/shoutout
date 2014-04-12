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

@interface MapViewController : UIViewController<GMSMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIView *map;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) NSMutableArray * markerArray;
@property (strong, nonatomic) NSMutableArray * statusArray;
@property (strong, nonatomic) NSMutableDictionary * markerDictionary;

@end
