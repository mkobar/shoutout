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
    // Do any additional setup after loading the view.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.1105
                                                            longitude:-88.2284
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:self.map.bounds camera:camera];
    mapView_.myLocationEnabled = YES;
    [self.map addSubview:mapView_];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(40.1105, -88.2284);
    marker.title = @"mjmayank";
    marker.snippet = @"Excited to be at HackIllinois!";
    marker.map = mapView_;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
