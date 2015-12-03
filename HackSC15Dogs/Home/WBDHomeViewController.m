//
//  WBDHomeViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDHomeViewController.h"
#import <CoreLocation/CoreLocation.h>
//#import "WBDAWSCaller.h"
#import "WBDSearchProfileViewController.h"
#import "WBDFilterViewController.h"
#import "WBDCreateWalkViewController.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppDelegate.h"


@import GoogleMaps;
@interface WBDHomeViewController () <GMSMapViewDelegate, FBSDKLoginButtonDelegate>
@property (strong, nonatomic) UISegmentedControl *searchSwitcher;
@property (strong, nonatomic) GMSMapView *mapGMSMapView;
@property (strong, nonatomic) CLLocationManager * mapCLLocationManager;
@property (strong, nonatomic) UICollectionView *featuredList;
@property (strong, nonatomic) UIView *loginView;
@end

@implementation WBDHomeViewController

static BOOL showMarkers = YES;

- (void )viewWillAppear:(BOOL)animated{
    if ([FBSDKAccessToken currentAccessToken]){
        [self.tabBarController.tabBar setHidden:NO];
        self.view.backgroundColor = [UIColor whiteColor];
    }else{
        [self.tabBarController.tabBar setHidden:YES];
    }
}

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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:34.0203056
                                                            longitude:-118.2886556
                                                                 zoom:16];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.mapGMSMapView = [GMSMapView mapWithFrame:CGRectMake(0,
                                                             0,
                                                             screenWidth,
                                                             screenHeight - self.navigationController.navigationBar.frame.size.height - self.searchSwitcher.frame.size.height)
                                           camera:camera];
    
    self.mapGMSMapView.camera = camera;
    self.mapGMSMapView.delegate = self;
    self.mapGMSMapView.myLocationEnabled = YES;
    
    [self.view addSubview:self.mapGMSMapView];
    //http://stackoverflow.com/questions/15417811/cannot-put-a-google-maps-gmsmapview-in-a-subview-of-main-main-view
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    NSLog(@"clicked marker");
    return NO;
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    NSLog(@"Clicked infowindow");
    [self.navigationController pushViewController:[[WBDSearchProfileViewController alloc] init] animated:YES];
}

- (void) addMarkers{
    // Creates a marker in the center of the map.
    GMSMarker *markerFirst = [[GMSMarker alloc] init];
    markerFirst.position = CLLocationCoordinate2DMake(34.0204478, -118.2892725);
    markerFirst.title = @"Fido";
    markerFirst.snippet = @"heading over";
    markerFirst.map = self.mapGMSMapView;
    markerFirst.icon = [UIImage imageNamed:@"gmPin.png"];

    // Creates a marker in the center of the map.
    GMSMarker *markerSecond = [[GMSMarker alloc] init];
    markerSecond.position = CLLocationCoordinate2DMake(34.0206968, -118.2890257);
    markerSecond.title = @"Molly";
    markerSecond.snippet = @"playing";
    markerSecond.map = self.mapGMSMapView;
    markerSecond.icon = [UIImage imageNamed:@"gmPin.png"];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.15 green:0.67 blue:0.75 alpha:1.0];
    [self locationSetup];
    [self googleMapsSampleSetup];
    
//    self.searchSwitcher = [[UISegmentedControl alloc] initWithItems:@[@"Out and about", @"Featured"] ];
//    self.searchSwitcher.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, 25);
//    self.searchSwitcher.selectedSegmentIndex = 0;
//    [self.searchSwitcher addTarget:self action:@selector(segmentedSelected) forControlEvents:UIControlEventValueChanged];
//    
//    [self.view addSubview:self.searchSwitcher];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconSearch.png"] style:UIBarButtonItemStylePlain target:self action:@selector(changeToFilter)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"walkDog"] style:UIBarButtonItemStylePlain target:self action:@selector(goOnWalk)];

    if (showMarkers == YES){
        [self addMarkers];
    }
    
    if (showMarkers == NO)
    {
        showMarkers = YES;
    }
}

- (void) viewDidAppear:(BOOL)animated{
    if (![FBSDKAccessToken currentAccessToken]){
        [self showLogin];
    }
}

- (void)showLogin{
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
    self.loginView = [[UIView alloc] init];
    self.loginView.frame = self.view.frame;
    [self.view addSubview:self.loginView];
    [self.view bringSubviewToFront:self.loginView];

    self.loginView.backgroundColor = [UIColor cyanColor];

    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.loginView.center;
    loginButton.delegate = self;
    [self.loginView addSubview:loginButton];
}

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    if (!error){

        NSLog(@"not an error");
        NSString * appID = [[FBSDKAccessToken currentAccessToken] appID];
        [[NSUserDefaults standardUserDefaults] setValue:appID forKey:@"appID"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        //check if user is in db already with conditional put

        //create user
        //{ operation: create
        // tableName: User
        // conditionalExpression: "attribute_not_exist(ID)"
        // Item:{
        //  ID:"appID"}
        NSDictionary *item = @{@"ID": appID};
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"create" forKey:@"operation"];
        [dict setObject:@"User" forKey:@"TableName"];
        [dict setObject:item forKey:@"Item"];
        [dict setObject:@"attribute_not_exists(ID)" forKey:@"ConditionExpression"];

        AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
        [[lambdaInvoker invokeFunction:@"arn:aws:lambda:us-east-1:672822236713:function:HackSCTest2"
                            JSONObject:dict] continueWithBlock:^id(AWSTask *task) {
            if (task.error) {
                NSLog(@"Error: %@", task.error);
            }
            if (task.exception) {
                NSLog(@"Exception: %@", task.exception);
            }
            if (task.result) {
                NSLog(@"Result: %@", task.result);
            }
            [self.loginView removeFromSuperview];
            self.loginView = nil;
            [self.tabBarController.tabBar setHidden:NO];
            [self.navigationController.navigationBar setHidden:NO];
            return nil;
        }];
    }else{
        NSLog(@"else");
    }
}


- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{

}

- (void)goOnWalk{
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController pushViewController:[[WBDCreateWalkViewController alloc] init] animated:YES];
}

- (void)changeToFilter{
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController pushViewController:[[WBDFilterViewController alloc] init] animated:YES];
}

- (void) fillDictionaryWithDictionary:(NSMutableDictionary *)dictionary{
    NSLog(@"WORKS TO HERE");
    NSLog(dictionary);
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
