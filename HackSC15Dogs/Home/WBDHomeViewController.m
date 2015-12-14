//
//  WBDHomeViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDHomeViewController.h"
#import "WBDWebProfileViewController.h"
#import "WBDCreateWalkViewController.h"
#import "AppDelegate.h"
#import "PlayDate.h"

#import <CoreLocation/CoreLocation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>

@import GoogleMaps;
@interface WBDHomeViewController () <GMSMapViewDelegate, FBSDKLoginButtonDelegate>
@property (strong, nonatomic) GMSMapView *mapGMSMapView;
@property (strong, nonatomic) CLLocationManager * mapCLLocationManager;
@property (strong, nonatomic) UIView *loginView;
@end

@implementation WBDHomeViewController

- (void )viewWillAppear:(BOOL)animated{
    if ([FBSDKAccessToken currentAccessToken]){
        [self.tabBarController.tabBar setHidden:NO];
        self.view.backgroundColor = [UIColor whiteColor];
        [self.loginView removeFromSuperview];
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

- (void)googleMapsSetup{
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
                                                             screenHeight - self.navigationController.navigationBar.frame.size.height)
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

    WBDWebProfileViewController *vc = [[WBDWebProfileViewController alloc] init];
    PlayDate *pd = marker.userData;
    PFUser *walker = pd[@"Walker"];
    [walker fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error){
            vc.user = walker;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSLog([error localizedDescription]);
        }
    }];
}

- (void) addMarkers: (NSMutableArray *)dates stopToCheck: (BOOL)check{
    NSLog(@"Marker count: %ld", [dates count]);
    
    if (check){
        if ([dates count] == 0){
            [self performDateSearchInBackground];
            return;
        }
    }
    
    dispatch_apply([dates count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(size_t i){
        PlayDate *date = [dates objectAtIndex:i];
        PFGeoPoint *location = date[@"Location"];
        NSLog(@"Location added: %@", location);
        
        PFUser *walker = date[@"Walker"];
        [walker fetch];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
            marker.title = walker[@"Name"];
            marker.draggable = NO;
            marker.snippet = (date[@"isStarted"] ? @"Playing" : @"Heading over");
            marker.icon = [UIImage imageNamed:@"gmPin.png"];
            marker.map = self.mapGMSMapView;
            marker.userData = date;
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.15 green:0.67 blue:0.75 alpha:1.0];
    [self locationSetup];
    [self googleMapsSetup];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"walkDog"] style:UIBarButtonItemStylePlain target:self action:@selector(goOnWalk)];
}

- (void) viewDidAppear:(BOOL)animated{
    if ([FBSDKAccessToken currentAccessToken] == nil){
        NSLog(@"No Facebook!");
        [self showLogin];
    }else if ([PFUser currentUser] == nil){
        NSLog(@"Facebook but no user!");
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id,name"}];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error){
                [PFUser logInWithUsernameInBackground:[((NSDictionary *)result) objectForKey:@"id"]
                                             password:[((NSDictionary *)result) objectForKey:@"name"]
                                                block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                                                    if (error){
                                                        NSLog([error localizedDescription]);
                                                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Could not login successfully"
                                                                                                                                 message:@"Please log out and log in again."
                                                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                                                        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                          handler:^(UIAlertAction * _Nonnull action) {}]];
                                                        [self presentViewController:alertController animated:YES completion:nil];
                                                    }
                                                }];
            }
        }];
    }else{
        NSLog(@"Facebook and user!");
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"picture,link"}];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            NSDictionary *resultJSON = (NSDictionary *)result;
            PFUser *user = [PFUser currentUser];
            NSString *link = [resultJSON objectForKey:@"link"];
            NSString *picture;
            
            bool is_silhouette = [[[resultJSON objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"is_silhouette"];
            if (is_silhouette == 1){
                picture = [[[resultJSON objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
            }else{
                picture = @"";
            }
            user[@"Image"] = picture;
            user[@"Url"] = link;
            
            [user saveInBackground];
        }];
    }
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [self addMarkers:delegate.dates stopToCheck:YES];
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
    loginButton.readPermissions = @[@"user_website", @"public_profile", @"user_friends"];
    loginButton.publishPermissions = @[@"publish_actions"];
    [self.loginView addSubview:loginButton];
}

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    if (!error){
        NSDictionary *params = @{@"fields": @"id,name,link,picture"};
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:params];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            NSDictionary *resultJSON = (NSDictionary *)result;
            NSString *userText = [resultJSON objectForKey:@"id"];
            NSString *passText = [resultJSON objectForKey:@"name"];
            NSString *link = [resultJSON objectForKey:@"link"];
            NSString *picture;
            
            if ([[[resultJSON objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"is_silhouette"] == NO){
                picture = [[[resultJSON objectForKey:@"picture]"] objectForKey:@"data"] objectForKey:@"url"];
            }else{
                picture = @"";
            }
            
            [PFUser logInWithUsernameInBackground:userText password:passText block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                if (error){
                    PFUser *newUser = [PFUser user];
                    newUser.username = userText;
                    newUser.password = passText;
                    newUser[@"Name"] = passText;
                    newUser[@"Image"] = picture;
                    newUser[@"Url"] = link;
                    newUser[@"Dogs"] = @[];
                    
                    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        [self.loginView removeFromSuperview];
                        [self.tabBarController.tabBar setHidden:NO];
                        [self.navigationController.navigationBar setHidden:NO];

                        NSLog(@"not an error");
                        NSString * appID = [[FBSDKAccessToken currentAccessToken] appID];
                        [[NSUserDefaults standardUserDefaults] setValue:appID forKey:@"appID"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }];
                }else{
                    [self.loginView removeFromSuperview];
                    [self.tabBarController.tabBar setHidden:NO];
                    [self.navigationController.navigationBar setHidden:NO];
                    
                    NSLog(@"not an error");
                    NSString * appID = [[FBSDKAccessToken currentAccessToken] appID];
                    [[NSUserDefaults standardUserDefaults] setValue:appID forKey:@"appID"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            } ];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) performDateSearchInBackground{
    UIDevice *device = [UIDevice currentDevice];
    
    if (![device isMultitaskingSupported]){
        return;
    }
    
    dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0);
    dispatch_async(background, ^{
        __block UIBackgroundTaskIdentifier bTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:bTask];
            bTask = UIBackgroundTaskInvalid;
        }];
        
        PFQuery *playDateQuery = [PFQuery queryWithClassName:@"PlayDate"];
        [playDateQuery whereKey:@"isOver" equalTo:@(NO)];
        [playDateQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addMarkers:[objects mutableCopy] stopToCheck:NO];
                });
            }
            
            [[UIApplication sharedApplication] endBackgroundTask:bTask];
            bTask = UIBackgroundTaskInvalid;
        }];
    });
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
