//
//  WBDHomeViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDHomeViewController.h"
#import <CoreLocation/CoreLocation.h>

@import GoogleMaps;
@interface WBDHomeViewController ()
@property (strong, nonatomic) UISegmentedControl *searchSwitcher;
@property (strong, nonatomic) GMSMapView *mapGMSMapView;
@property (strong, nonatomic) CLLocationManager * mapCLLocationManager;
@property (strong, nonatomic) UICollectionView *featuredList;
@end

@implementation WBDHomeViewController{
    GMSMapView *mapView_;
}

-(void) locationSetup{
    self.mapCLLocationManager = [[CLLocationManager alloc] init];
    self.mapCLLocationManager.delegate = self;
    //self.mapCLLocationManager.distanceFilter = 1.0f;
    self.mapCLLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
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
    NSLog( error.localizedDescription );
}

- (void)googleMapsSampleSetup{
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.mapGMSMapView = [GMSMapView mapWithFrame:CGRectMake(0,
                                                             0,
                                                             screenWidth,
                                                             screenHeight)
                                           camera:camera];
    
    self.mapGMSMapView.camera = camera;
    self.mapGMSMapView.myLocationEnabled = YES;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = self.mapGMSMapView;
    
    [self.view addSubview:self.mapGMSMapView];
    
    //http://stackoverflow.com/questions/15417811/cannot-put-a-google-maps-gmsmapview-in-a-subview-of-main-main-view
}

- (void) segmentedSelected{
    if (self.searchSwitcher.selectedSegmentIndex == 0){
        for (UIView *v in [self.view subviews]){
            if ([v isKindOfClass:[UICollectionView class]]){
                [v removeFromSuperview];
            }
        }
        [self.view addSubview:self.searchSwitcher];
        [self.view addSubview:self.mapGMSMapView];
        [self.view sendSubviewToBack:self.mapGMSMapView];
    }else{
        for (UIView *v in [self.view subviews]){
            if ([v isKindOfClass:[GMSMapView class]]){
                [v removeFromSuperview];
            }
        }
        [self.view addSubview:self.searchSwitcher];
        [self.view addSubview:self.featuredList];
        [self.view sendSubviewToBack:self.featuredList];
    }
}

+ (SEL)getFilterSelector{
    return @selector(filterPressed);
}

- (void)filterPressed{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self locationSetup];
    [self googleMapsSampleSetup];
    
    self.searchSwitcher = [[UISegmentedControl alloc] initWithItems:@[@"Out and about", @"Featured"] ];
    self.searchSwitcher.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, 25);
    self.searchSwitcher.selectedSegmentIndex = 0;
    [self.searchSwitcher addTarget:self action:@selector(segmentedSelected) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.searchSwitcher];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionView *)featuredList{
    if (!_featuredList){
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _featuredList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) collectionViewLayout:layout];
        [_featuredList setBackgroundColor:[UIColor whiteColor]];
    }
    
    return _featuredList;
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
