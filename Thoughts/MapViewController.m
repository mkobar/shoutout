//
//  MapViewController.m
//  Thoughts
//
//  Created by Mayank Jain on 4/12/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "MapViewController.h"
#import <Mapbox/Mapbox.h>

//#59bbcf turqoise colo

//2bcbe0 different shades of turqoise

BOOL googleMaps = false;
BOOL mapbox = true;

@interface MapViewController ()

@end

@implementation MapViewController{
    GMSMapView *mapView_;
    RMMapView *mapViewR;
}

@synthesize markerDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.markerDictionary = [[NSMutableDictionary alloc] init];
    self.markerArray = [[NSMutableArray alloc] init];
    self.statusArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    self.searchTextField.delegate = self;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.1105
                                                            longitude:-88.2284
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:self.map.bounds camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.delegate = self;
//    [self.map addSubview:mapView_];
    
    
    
    
    
    
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"mjmayank.hpa3bj3b"];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(40.1105, -88.2284);
    mapViewR = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource centerCoordinate:centerCoordinate zoomLevel:9.0 maxZoomLevel:15.0 minZoomLevel:1.0 backgroundImage:nil];
    
    mapViewR.delegate = self;
    
    [self.map addSubview:mapViewR];
    
    
    // Create a PFGeoPoint using the current location (to use in our query)
//    CLLocation *currentLocation = [[AppDelegate sharedLocationManager] location];
//    [AppDelegate sharedLocationManager].delegate = self;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    CLLocation * locationInfo;
    [nc addObserver:self selector:@selector(locationDidUpdate) name:@"LocationUpdate" object:locationInfo];
    
    
    Firebase* shoutoutRoot = [[Firebase alloc] initWithUrl:@"https://shoutout.firebaseio.com/"];
    
    [shoutoutRoot observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        [self animateUser:snapshot.name toNewPosition:snapshot.value];
    }];
    
    UIImage * image;
    
    image = [UIImage imageWithData:
             [NSData dataWithContentsOfURL:
              [NSURL URLWithString: [PFUser currentUser][@"picURL"]]]];
    self.profilePic.image = image;
    self.profilePic.layer.cornerRadius = 35.0;
    self.profilePic.layer.masksToBounds = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    PFGeoPoint *userLocation =
    [PFGeoPoint geoPointWithLatitude:40.1105
                           longitude:-88.2284];
    
    // Construct query
    PFQuery *query = [PFUser query];
    [query whereKey:@kParseObjectGeoKey nearGeoPoint:userLocation withinKilometers:5000];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            NSLog(@"Successfully retrieved %lu statuses.", (unsigned long)objects.count);
            
            for (PFObject * obj in objects){
                
                
                RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapViewR
                                                                       coordinate:CLLocationCoordinate2DMake(((PFGeoPoint *)obj[@"geo"]).latitude, ((PFGeoPoint *)obj[@"geo"]).longitude)
                                                                         andTitle:obj[@"status"]];
                
                annotation.userInfo = obj;
                annotation.anchorPoint = CGPointMake(24, 56);
                [mapViewR addAnnotation:annotation];
                
                
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
                    newmark.map = mapView_;
                    
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
                [self.markerDictionary setObject:annotation forKey:[obj objectId]];
                
                [mapView_ setSelectedMarker:newmark];
                
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [mapView_ setSelectedMarker:toShow];
    }
}

-(void) mapViewRegionDidChange:(RMMapView *)mapView{
    CLLocationDegrees centerLatitude = mapView.centerCoordinate.latitude;
    CLLocationDegrees centerLongitude = mapView.centerCoordinate.longitude;
    
    CLLocation * screenCenter = [[CLLocation alloc] initWithLatitude:centerLatitude longitude:centerLongitude];
    
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

- (void)sortByDistanceFromLocation:(CLLocation *)location{
    
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

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
}

- (IBAction)shoutOutButtonPressed:(id)sender {
    
    if(!self.shelf){
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.slidingView setFrame:CGRectMake(self.slidingView.frame.origin.x, self.slidingView.frame.origin.y -170, self.slidingView.frame.size.width, self.slidingView.frame.size.height)];
                             self.slidingView.alpha = 1.0;
                         }
                         completion:nil];
        self.shelf = true;
    }
    else{
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.slidingView setFrame:CGRectMake(self.slidingView.frame.origin.x, self.slidingView.frame.origin.y +170, self.slidingView.frame.size.width, self.slidingView.frame.size.height)];
                             self.slidingView.alpha = .7;
                         }
                         completion:nil];
        self.shelf = false;
    }
}

-(void)locationDidUpdate{
//    NSLog(@"test");
//    [PFUser currentUser][@"geo"] = [PFGeoPoint geoPointWithLatitude:40.1108
//                                                          longitude:-88.2284];
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMMarker *marker;

    marker = [[RMMarker alloc] initWithUIImage:[self imageWithImage:[UIImage imageWithData:
                                                                                 [NSData dataWithContentsOfURL:
                                                                                  [NSURL URLWithString: annotation.userInfo[@"picURL"]]]] borderImage:[UIImage imageNamed:@"background.png"] covertToSize:CGSizeMake(48, 56)]];

    marker.canShowCallout = YES;
    
    return marker;
}

-(UIImage *)imageWithImage:(UIImage *)image borderImage:(UIImage *)borderImage covertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [borderImage drawInRect:CGRectMake( 0, 0, size.width, size.height )];
    [image drawInRect:CGRectMake( 4, 4, 40, 40)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)tapOnLabelForAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    NSLog(@"test");
}

- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    NSLog(@"test1");
}

- (void)doubleTapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    if([annotation.title rangeOfString:@"listening to " options:NSCaseInsensitiveSearch].location != NSNotFound){
        NSString * song = [annotation.title substringFromIndex:13];
        self.rdio = [[Rdio alloc] initWithConsumerKey:@"thrhvh2bkpy5devcntw4qat6" andSecret:@"Nrzm8K5G4m" delegate:nil];
        [self.rdio callAPIMethod:@"searchSuggestions" withParameters:[NSDictionary dictionaryWithObject:song forKey:@"query"] delegate:self];
    }
    
    if(annotation.userInfo[@"phone"]){
        MFMessageComposeViewController *viewController = [[MFMessageComposeViewController alloc] init];
        
        viewController.messageComposeDelegate = self;
        viewController.recipients = [[NSArray alloc] initWithObjects:annotation.userInfo[@"phone"], nil];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void) rdioRequest:(RDAPIRequest *)request didLoadData:(id)data{
    [self.rdio.player playSource:data[0][@"key"]];
}

- (void) animateUser:(NSString *)userID toNewPosition:(NSDictionary *)newMetadata {
    ((RMAnnotation *)self.markerDictionary[userID]).coordinate = CLLocationCoordinate2DMake([newMetadata[@"lat"] floatValue], [newMetadata[@"long"] floatValue] );
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        MKPointAnnotation *busPin = busMetadata.pin;
//        MKAnnotationView *busView = [self.map viewForAnnotation:busPin];
//        if(busView) {
//            CLLocationCoordinate2D newCoord = CLLocationCoordinate2DMake([[newMetadata objectForKey:@"lat"] doubleValue], [[newMetadata objectForKey:@"lon"] doubleValue]);
//            MKMapPoint mapPoint = MKMapPointForCoordinate(newCoord);
//            
//            CGPoint toPos;
//            CGFloat zoomFactor =  self.map.visibleMapRect.size.width / self.map.bounds.size.width;
//            toPos.x = mapPoint.x/zoomFactor;
//            toPos.y = mapPoint.y/zoomFactor;
//            
//            if (MKMapRectContainsPoint(self.map.visibleMapRect, mapPoint)) {
//                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//                animation.fromValue = [NSValue valueWithCGPoint:busView.center];
//                animation.toValue = [NSValue valueWithCGPoint:toPos];
//                animation.duration = 5.5;
//                animation.delegate = busView;
//                animation.fillMode = kCAFillModeForwards;
//                [busView.layer addAnimation:animation forKey:@"positionAnimation"];
//            }
//            
//            busView.center = toPos;
//            busMetadata.metadata = newMetadata;
//            [busPin setCoordinate:newCoord];
//        }
//    });
}

@end
