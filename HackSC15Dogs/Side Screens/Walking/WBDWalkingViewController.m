//
//  WBDWalkingViewController.m
//  HackSC15Dogs
//
//  Created by Chris Lee on 12/1/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDWalkingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@import GoogleMaps;

@interface WBDWalkingViewController () <GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *endWalkButton;
@property (strong, nonatomic) GMSMapView *mapGMSMapView;
@property (strong, nonatomic) CLLocationManager * mapCLLocationManager;
@property BOOL didStartWalk;

@end

@implementation WBDWalkingViewController

-(void) locationSetup{
    self.mapCLLocationManager = [[CLLocationManager alloc] init];
    [self.mapCLLocationManager requestWhenInUseAuthorization];
    self.mapCLLocationManager.delegate = self;
    //self.mapCLLocationManager.distanceFilter = 1.0f;
    self.mapCLLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    //user req, info plist, text ask user, delegate location manager
    [self.mapCLLocationManager requestLocation];
    //[self.mapCLLocationManager startUpdatingLocation];
}

//PROTOCOL
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    NSLog(@"didupdatelocations");
    CLLocation * newLocation = [locations lastObject];
    NSNumber *lat = [NSNumber numberWithDouble:newLocation.coordinate.latitude];
    NSNumber *longtitude = [NSNumber numberWithDouble:newLocation.coordinate.longitude];
    NSLog( @"Location is: (%f, %f)", [lat floatValue], [longtitude floatValue]);
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog( @"could not find location");
}

- (void)googleMapsSampleSetup{
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    PFGeoPoint *location = self.date[@"Location"];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude
                                                            longitude:location.longitude
                                                                 zoom:16];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.mapGMSMapView = [GMSMapView mapWithFrame:CGRectMake(0,
                                                             0,
                                                             screenWidth,
                                                             screenHeight - self.navigationController.navigationBar.frame.size.height - self.endWalkButton.frame.size.height)
                                           camera:camera];
    
    self.mapGMSMapView.camera = camera;
    self.mapGMSMapView.delegate = self;
    self.mapGMSMapView.myLocationEnabled = YES;
    
    GMSMarker *marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
    marker.draggable = NO;
    marker.icon = [UIImage imageNamed:@"gmPin"];
    [marker setMap:self.mapGMSMapView];
    
    [self.view addSubview:self.mapGMSMapView];
    //http://stackoverflow.com/questions/15417811/cannot-put-a-google-maps-gmsmapview-in-a-subview-of-main-main-view
}

- (IBAction)endWalkPressed:(id)sender {
    if (self.didStartWalk){
        PFUser *current = [PFUser currentUser];
        current[@"CurrentDate"] = [[NSNull alloc] init];
        [current saveInBackground];
        
        self.date[@"isOver"] = @(YES);
        [self.date saveInBackground];
        
        [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        self.didStartWalk = YES;
        [self.endWalkButton setTitle:@"End Walk" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.endWalkButton setTitle:@"I'm here!" forState:UIControlStateNormal];
    self.didStartWalk = NO;
    [self locationSetup];
    [self googleMapsSampleSetup];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
