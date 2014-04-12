//
//  MapViewController.m
//  Thoughts
//
//  Created by Mayank Jain on 4/12/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController{
    GMSMapView *mapView_;
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
    [self.map addSubview:mapView_];
    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(40.1105, -88.2284);
//    marker.title = @"mjmayank";
//    marker.snippet = @"Excited to be at HackIllinois!";
//    marker.map = mapView_;
//    
//    [mapView_ setSelectedMarker:marker];
//    
//    GMSMarker *marker2 = [[GMSMarker alloc] init];
//    marker2.position = CLLocationCoordinate2DMake(40.1205, -88.2284);
//    marker2.title = @"melugoyal";
//    marker2.snippet = @"Yo!";
//    marker2.map = mapView_;
    
    
    // Create a PFGeoPoint using the current location (to use in our query)
//    CLLocation *currentLocation = [[AppDelegate sharedLocationManager] location];
//    [AppDelegate sharedLocationManager].delegate = self;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    PFGeoPoint *userLocation =
    [PFGeoPoint geoPointWithLatitude:40.1105
                           longitude:-88.2284];
    
    // Construct query
    PFQuery *query = [PFUser query];
    [query whereKey:@kParseObjectGeoKey nearGeoPoint:userLocation withinKilometers:50];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            NSLog(@"Successfully retrieved %lu statuses.", (unsigned long)objects.count);
            
            for (PFObject * obj in objects){
                GMSMarker *newmark = [[GMSMarker alloc] init];
                
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
                [self.statusArray addObject:obj];
                
                if([self.markerDictionary objectForKey:[obj objectId]]){
                    ((GMSMarker *)[self.markerDictionary objectForKey:[obj objectId]]).map = nil;
                }
                [self.markerDictionary setObject:newmark forKey:[obj objectId]];
                
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
    
    CGRect rect = CGRectMake(0, 0, 40, 40);
//    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
//    CGContextFillEllipseInRect(ctx, rect);
    
    rect = CGRectMake(0, 0, 40, 40);
    CGContextDrawImage(ctx, rect, image.CGImage);
    
    UIImage *drawnImage = UIGraphicsGetImageFromCurrentImageContext();
    return drawnImage;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
}

@end
