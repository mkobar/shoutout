//
//  MapViewController.m
//  Thoughts
//
//  Created by Mayank Jain on 4/12/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "MapViewController.h"
#import "Mapbox.h"
#import "NewFilterBar.h"
#import "ShoutRMMarker.h"

//#59bbcf turqoise colo

//2bcbe0 different shades of turqoise

BOOL googleMaps = false;
BOOL mapbox = true;

@interface MapViewController ()
@property (nonatomic, strong) AddShoutWindow *addShoutWindow;
@property (nonatomic, strong) NSString *myImageUrl;
@property BOOL locationFirstSet;
@property UIImageView *messagesView;
@end

@implementation MapViewController{
    RMMapView *mapViewR;
}

@synthesize markerDictionary;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationFirstSet = NO;
    self.markerDictionary = [[NSMutableDictionary alloc] init];
    self.markerArray = [[NSMutableArray alloc] init];
    self.statusArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    self.statusTextField.layer.cornerRadius = 4.0f;
    [self.doneButton setHidden:YES];
    
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"zakavila.i74a6maa"];
    mapViewR = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource centerCoordinate:CLLocationCoordinate2DMake(0.0f, 0.0f) zoomLevel:9.0 maxZoomLevel:20.0 minZoomLevel:1.0 backgroundImage:nil];
    
    mapViewR.tileSourcesZoom = 17.0;
    
    mapViewR.delegate = self;
    
    [self.map addSubview:mapViewR];
    
    
    // Create a PFGeoPoint using the current location (to use in our query)
//    CLLocation *currentLocation = [[AppDelegate sharedLocationManager] location];
//    [AppDelegate sharedLocationManager].delegate = self;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    CLLocation * locationInfo;
    [nc addObserver:self selector:@selector(locationDidUpdate:) name:@"LocationUpdate" object:locationInfo];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    self.shoutoutRoot = [[Firebase alloc] initWithUrl:@"https://shoutout.firebaseio.com/loc"];
    self.shoutoutRootStatus = [[Firebase alloc] initWithUrl:@"https://shoutout.firebaseio.com/status"];
    self.shoutoutRootPrivacy = [[Firebase alloc] initWithUrl:@"https://shoutout.firebaseio.com/privacy"];
    
    [self.shoutoutRoot observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        [self animateUser:snapshot.name toNewPosition:snapshot.value];
    }];
    
    [self.shoutoutRootStatus observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        [self changeUserStatus:snapshot.name toNewStatus:snapshot.value];
    }];
    
    [self.shoutoutRootPrivacy observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        [self changeUserPrivacy:snapshot.name toNewPrivacy:snapshot.value];
    }];
    
    UIImage * image;
    
    image = [UIImage imageWithData:
             [NSData dataWithContentsOfURL:
              [NSURL URLWithString: [PFUser currentUser][@"picURL"]]]];
    self.profilePic.image = image;
    self.profilePic.layer.cornerRadius = 35.0;
    self.profilePic.layer.masksToBounds = YES;
    
    if ([PFUser currentUser])
        self.myImageUrl = [NSString stringWithString:[PFUser currentUser][@"picURL"]];
    
    self.statusTextField.delegate = self;
    
    CGFloat toolBarHeight = self.view.frame.size.height/9;
    CustomToolBar *toolBar = [[CustomToolBar alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height-toolBarHeight*3/2, self.view.frame.size.width, toolBarHeight*3/2)];
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 22.0f, self.view.frame.size.width-40, 30.0f)];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeySearch;
    textField.backgroundColor = [UIColor colorWithWhite:1.0f alpha:.80f];
    textField.layer.cornerRadius = 5.0f;
    [self.view addSubview:textField];
    
    NewFilterBar *filterBar = [[NewFilterBar alloc] initWithFrame:CGRectMake(0.0f, 54.0f, self.view.frame.size.width, toolBarHeight*3/2)];
    [self.view addSubview:filterBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;

    [self.saveButton.layer setCornerRadius:4.0f];
    PFGeoPoint *userLocation =
    [PFGeoPoint geoPointWithLatitude:40.1105
                           longitude:-88.2284];
    
    [self updateMapWithLocation:userLocation];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self promptLogin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateMapWithLocation:(PFGeoPoint *)userLocation{
    // Construct query
    PFQuery *query = [PFUser query];
    [query whereKey:@kParseObjectGeoKey nearGeoPoint:userLocation withinKilometers:50000];
    [query whereKey:@kParseObjectVisibleKey equalTo:[NSNumber numberWithBool:YES]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            NSLog(@"Successfully retrieved %lu statuses.", (unsigned long)objects.count);
            
            for (PFObject * obj in objects){
                //                NSString * caption = [obj[@"username"] stringByAppendingString:[NSString stringWithFormat:@": %@", obj[@"status"]]];
                
                RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapViewR
                                                                      coordinate:CLLocationCoordinate2DMake(((PFGeoPoint *)obj[@"geo"]).latitude, ((PFGeoPoint *)obj[@"geo"]).longitude)
                                                                        andTitle:obj[@"status"]];
                
                annotation.userInfo = obj;
                annotation.anchorPoint = CGPointMake(24, 56);
                
                if(obj[@"visible"]){
                    [mapViewR addAnnotation:annotation];
                }
                
                
                GMSMarker *newmark;
                if(googleMaps){
                    newmark = [[GMSMarker alloc] init];
                    UIImage * image;
                    
                    if(obj[@"picURL"]){
                        image = [UIImage imageWithData:
                                 [NSData dataWithContentsOfURL:
                                  [NSURL URLWithString: obj[@"picURL"]]]];
                    }
                    
                    
                    newmark.icon = [self drawPin:image];
                    newmark.position = CLLocationCoordinate2DMake(((PFGeoPoint *)obj[@"geo"]).latitude, ((PFGeoPoint *)obj[@"geo"]).longitude);
                    newmark.title = obj[@"username"];
                    newmark.snippet = obj[@"status"];
                    
                    [self.markerArray addObject:newmark];
                    if([self.markerDictionary objectForKey:[obj objectId]]){
                        ((GMSMarker *)[self.markerDictionary objectForKey:[obj objectId]]).map = nil;
                    }
                    [self.markerDictionary setObject:newmark forKey:[obj objectId]];
                }
                
                [self.markerArray addObject:annotation];
                [self.statusArray addObject:obj];
                
                if([self.markerDictionary objectForKey:[obj objectId]]){
                    [mapViewR removeAnnotation:[self.markerDictionary objectForKey:[obj objectId]]];
                }
                
                if(obj[@"visible"]){
                    [self.markerDictionary setObject:annotation forKey:[obj objectId]];
                }
                
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    if([self.statusArray count] != 0){
        NSLog(@"%f, %f", [mapView.camera target].latitude, [mapView.camera target].longitude);
        
        CLLocationDegrees centerLatitude = [mapView.camera target].latitude;
        CLLocationDegrees centerLongitude = [mapView.camera target].longitude;
        
        CLLocation * screenCenter = [[CLLocation alloc] initWithLatitude:centerLatitude longitude:centerLongitude];
        
        CLLocationDistance minDistance = [screenCenter distanceFromLocation:[[CLLocation alloc] initWithLatitude:((PFGeoPoint *)self.statusArray[0][@"geo"]).latitude longitude:((PFGeoPoint *)self.statusArray[0][@"geo"]).longitude]];
        GMSMarker * toShow = self.markerArray[0];
        
        for(int i = 0; i<[self.statusArray count]; i++){
            PFObject * status = self.statusArray[i];
            
            CLLocation * loc = [[CLLocation alloc] initWithLatitude:((PFGeoPoint *)status[@"geo"]).latitude longitude:((PFGeoPoint *)status[@"geo"]).longitude];
            
            CLLocationDistance distance = [screenCenter distanceFromLocation:loc];
            
            if(distance <= minDistance){
                minDistance = distance;
                toShow = self.markerArray[i];
            }
            
        }
    }
}

-(void) mapViewRegionDidChange:(RMMapView *)mapView{
    CLLocationDegrees centerLatitude = mapView.centerCoordinate.latitude;
    CLLocationDegrees centerLongitude = mapView.centerCoordinate.longitude;
    
    CLLocation * screenCenter = [[CLLocation alloc] initWithLatitude:centerLatitude longitude:centerLongitude];
    
    if (self.statusArray.count == 0)
        return;
    
    CLLocationDistance minDistance = [screenCenter distanceFromLocation:[[CLLocation alloc] initWithLatitude:((PFGeoPoint *)self.statusArray[0][@"geo"]).latitude longitude:((PFGeoPoint *)self.statusArray[0][@"geo"]).longitude]];
    RMAnnotation * toShow = self.markerArray[0];
    
    for(int i = 0; i<[self.statusArray count]; i++){
        PFObject * status = self.statusArray[i];
        
        CLLocation * loc = [[CLLocation alloc] initWithLatitude:((PFGeoPoint *)status[@"geo"]).latitude longitude:((PFGeoPoint *)status[@"geo"]).longitude];
        
        CLLocationDistance distance = [screenCenter distanceFromLocation:loc];
        
        if(distance <= minDistance){
            minDistance = distance;
            toShow = self.markerArray[i];
        }
    }
    [mapView selectAnnotation:toShow animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.doneButton setHidden:NO];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.doneButton setHidden:YES];
}

-(UIImage *) drawPin:(UIImage *) image{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(40, 40), NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIImage * background = [UIImage imageNamed:@"background.png"];
    
    CGRect rect = CGRectMake(0, 0, 45, 45);
    CGContextDrawImage(ctx, rect, background.CGImage);
//    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
//    CGContextFillEllipseInRect(ctx, rect);
    
//    CGContextScaleCTM(ctx, 1.0, -1.0);
    rect = CGRectMake(0, 0, 40, 40);
    CGContextDrawImage(ctx, rect, image.CGImage);
    
    UIImage *drawnImage = UIGraphicsGetImageFromCurrentImageContext();
    return drawnImage;
}

- (void)toolBar:(CustomToolBar *)toolBar didSelectButton:(UIButton *)button
{
    if (button == toolBar.addShoutButton) {
        if (!self.addShoutWindow) {
            self.addShoutWindow = [[AddShoutWindow alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 192.0f)];
            self.addShoutWindow.delegate = self;
            self.addShoutWindow.frame = CGRectMake(self.view.frame.size.width/8, self.view.frame.size.height/3, self.addShoutWindow.frame.size.width, self.addShoutWindow.frame.size.height);
            [self.view addSubview:self.addShoutWindow];
        }
        else {
            [self.addShoutWindow removeFromSuperview];
            self.addShoutWindow = nil;
        }
    }
    else if (button == toolBar.addButton && self.addShoutWindow) {
        [self.addShoutWindow removeFromSuperview];
        self.addShoutWindow = nil;
    }
    else if (button == toolBar.messagesButton) {
        if (!self.messagesView) {
            self.messagesView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessagePopup"]];
            self.messagesView.frame = CGRectMake(self.view.frame.size.width/2-[UIImage imageNamed:@"MessagePopup"].size.width/2, self.view.frame.size.height/2-[UIImage imageNamed:@"MessagePopup"].size.height/2, [UIImage imageNamed:@"MessagePopup"].size.width, [UIImage imageNamed:@"MessagePopup"].size.height);
            [self.view addSubview:self.messagesView];
        }
        else {
            [self.messagesView removeFromSuperview];
            self.messagesView = nil;
        }
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    [self saveButtonPressed:nil];
//    [self.statusTextField resignFirstResponder];
}

//- (IBAction)shoutOutButtonPressed:(id)sender {
//    
//    if(!self.shelf){
//        [UIView animateWithDuration:0.3f
//                              delay:0.0f
//                            options:UIViewAnimationOptionCurveLinear
//                         animations:^{
//                             [self.slidingView setFrame:CGRectMake(self.slidingView.frame.origin.x, self.slidingView.frame.origin.y -170, self.slidingView.frame.size.width, self.slidingView.frame.size.height)];
//                             self.slidingView.alpha = 1.0;
//                         }
//                         completion:nil];
//        self.shelf = true;
//    }
//    else{
//        [UIView animateWithDuration:0.3f
//                              delay:0.0f
//                            options:UIViewAnimationOptionCurveLinear
//                         animations:^{
//                             [self.slidingView setFrame:CGRectMake(self.slidingView.frame.origin.x, self.slidingView.frame.origin.y +170, self.slidingView.frame.size.width, self.slidingView.frame.size.height)];
//                             self.slidingView.alpha = .7;
//                         }
//                         completion:nil];
//        self.shelf = false;
//        [self.statusTextField resignFirstResponder];
//    }
//}

-(void)locationDidUpdate:(NSNotification *)notification{
//    NSLog(@"test");
    CLLocation * location = notification.object;
    
    NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude ];
    NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude ];
    /*[self.shoutoutRoot observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
    }];
     */
    if([PFUser currentUser]){
        [[self.shoutoutRoot childByAppendingPath:[[PFUser currentUser] objectId]] updateChildValues:@{@"lat": latitude, @"lon": longitude}];
        
        [PFUser currentUser][@"geo"] = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    }
    if (!self.locationFirstSet) {
//        [mapViewR setCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
        [mapViewR setZoom:17.0f atCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) animated:NO];
        self.locationFirstSet = YES;
    }
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMMarker *marker;
    marker = [[ShoutRMMarker alloc] initShoutWithUIImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: annotation.userInfo[@"picURL"]]]] andAnnotation:annotation];
    marker.canShowCallout = NO;
    return marker;
}

-(UIImage *)imageWithImage:(UIImage *)image borderImage:(UIImage *)borderImage covertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [borderImage drawInRect:CGRectMake( 0, 0, size.width, size.height )];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2,2,44,44) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(20.0f, 20.0f)].CGPath;
    CGContextAddPath(ctx, clippath);
    CGContextClip(ctx);
    [image drawInRect:CGRectMake( 2, 2, 44, 44)];
    CGContextRestoreGState(ctx);
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)tapOnMarker:(ButtonRMMarker*)marker at:(CGPoint)point
{
    for (CALayer *layer in marker.sublayers) {
        CGPoint convertedPoint = [layer convertPoint:point fromLayer:[marker superlayer]];
        if ([layer containsPoint:convertedPoint]&&layer.name) {
            [((ShoutRMMarker*)marker)didPressButtonWithName:layer.name];
        }
    }
}

- (void)tapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void) animateUser:(NSString *)userID toNewPosition:(NSDictionary *)newMetadata {
    ((RMAnnotation *)self.markerDictionary[userID]).coordinate = CLLocationCoordinate2DMake([newMetadata[@"lat"] floatValue], [newMetadata[@"lon"] floatValue] );
    ((RMAnnotation *)self.markerDictionary[userID]).title = newMetadata[@"status"];
    if ((RMAnnotation *)self.markerDictionary[userID]) {
        [mapViewR removeAnnotation:((RMAnnotation *)self.markerDictionary[userID])];
        [mapViewR addAnnotation:((RMAnnotation *)self.markerDictionary[userID])];
    }
    
}

- (void) changeUserStatus:(NSString *)userID toNewStatus:(NSDictionary *)newMetadata {
    ((RMAnnotation *)self.markerDictionary[userID]).title = newMetadata[@"status"];
    [mapViewR deselectAnnotation:((RMAnnotation *)self.markerDictionary[userID]) animated:NO];
    mapViewR.selectedAnnotation = ((RMAnnotation *)self.markerDictionary[userID]);
}

- (void) changeUserPrivacy:(NSString *)userID toNewPrivacy:(NSDictionary *)newMetadata {
    if([((NSString *)newMetadata[@"privacy"]) isEqualToString:@"NO"]){
        if(((RMAnnotation *)self.markerDictionary[userID]) != nil){
            [mapViewR removeAnnotation:((RMAnnotation *)self.markerDictionary[userID])];
        }
    }
    else{
        if(((RMAnnotation *)self.markerDictionary[userID]) != nil){
            [mapViewR addAnnotation:((RMAnnotation *)self.markerDictionary[userID])];
        }
        else{
            
        }
    }
}

-(void)promptLogin{
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        logInViewController.facebookPermissions = @[@"friends_about_me"];
        logInViewController.fields = PFLogInFieldsFacebook | PFLogInFieldsDismissButton; //Facebook login, and a Dismiss button.
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    else{
        self.statusTextField.text = [PFUser currentUser][@"status"];
    }
}

- (void)addShoutWindow:(AddShoutWindow *)addShoutWindow didPressButton:(UIButton *)button
{
    if (button == addShoutWindow.xButton) {
        [self.addShoutWindow removeFromSuperview];
        self.addShoutWindow = nil;
    }
    else if (button == addShoutWindow.postButton) {
        [PFUser currentUser][@"status"] = addShoutWindow.shoutContent.text;//self.statusTextField.text;
        [PFUser currentUser][@"visible"] = [NSNumber numberWithBool:YES];
        
        CLLocation *currentLocation = [[AppDelegate sharedLocationManager] location];
        
        PFGeoPoint *currentPoint = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude
                                                          longitude:currentLocation.coordinate.longitude];
        [[PFUser currentUser] setObject:currentPoint forKey:@kParseObjectGeoKey];
        
        [[PFUser currentUser] saveInBackground];
        
        [addShoutWindow.shoutContent resignFirstResponder];
        
        [[self.shoutoutRoot childByAppendingPath:[[PFUser currentUser] objectId]] updateChildValues:@{@"status": addShoutWindow.shoutContent.text}];
        
//        if(self.privacyToggle.on){
        [[[self.shoutoutRoot childByAppendingPath:[[PFUser currentUser] objectId]] childByAppendingPath:@"privacy" ] setValue:@"YES"];
//        }
//        else{
//            [[[self.shoutoutRoot childByAppendingPath:[[PFUser currentUser] objectId]] childByAppendingPath:@"privacy" ] setValue:@"NO"];
//        }
        
        PFGeoPoint *currentCenter = [PFGeoPoint geoPointWithLatitude:mapViewR.centerCoordinate.latitude longitude:mapViewR.centerCoordinate.longitude];
        //    [self updateMapWithLocation:currentCenter];
        
        [self.addShoutWindow removeFromSuperview];
        self.addShoutWindow = nil;
    }
}

#pragma mark -LoginDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            if(![PFUser currentUser][@"status"]){
                
                NSDictionary *userData = (NSDictionary *)result;
                
                NSString *facebookID = userData[@"id"];
                NSString *facebookUsername = userData[@"username"];
                
                NSString *pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200&height=200", facebookID];
                
                [[PFUser currentUser] setObject:pictureURL forKey:@"picURL"];
                [[PFUser currentUser] setObject:facebookUsername forKey:@"username"];
                [PFUser currentUser][@"status"] = @"Just a man and his thoughts";
                
                CLLocation *currentLocation = [[AppDelegate sharedLocationManager] location];
                
                PFGeoPoint *currentPoint = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude
                                                                  longitude:currentLocation.coordinate.longitude];
                [[PFUser currentUser] setObject:currentPoint forKey:@kParseObjectGeoKey];
                
                [[PFUser currentUser] saveInBackground];
            }
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    
    UIImage * image;
    
    image = [UIImage imageWithData:
             [NSData dataWithContentsOfURL:
              [NSURL URLWithString: [PFUser currentUser][@"picURL"]]]];
    self.profilePic.image = image;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
//    [self animateTextField:self.slidingView up:YES withInfo:notification.userInfo];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    [self animateTextField:self.slidingView up:NO withInfo:notification.userInfo];
}

- (void) animateTextField: (UIView*) view up: (BOOL) up withInfo:(NSDictionary *)userInfo
{
    const int movementDistance = 140; // tweak as needed
    NSTimeInterval movementDuration;
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&movementDuration]; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationCurve: animationCurve];
    [UIView setAnimationDuration: movementDuration];
    view.frame = CGRectOffset(view.frame, 0, movement);
    [UIView commitAnimations];
}
@end
