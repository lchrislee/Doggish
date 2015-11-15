//
//  WBDCreateWalkViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDCreateWalkViewController.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSLambda/AWSLambda.h>

@import GoogleMaps;
@interface WBDCreateWalkViewController () <UIPickerViewDelegate, UIPickerViewDataSource,
                                            UITableViewDataSource, UITableViewDelegate,
                                            GMSMapViewDelegate>
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) UIPickerView *timePicker;
@property (strong, nonatomic) NSArray *timesAvailable;
@property (nonatomic) NSUInteger timeDifference;
@property (strong, nonatomic) NSArray *dogs;

@property (strong, nonatomic) GMSMarker *marker;
@property (strong, nonatomic) GMSMapView *mapGMSMapView;
@property (strong, nonatomic) CLLocationManager * mapCLLocationManager;
@end

@implementation WBDCreateWalkViewController

-(void) locationSetup{
    self.mapCLLocationManager = [[CLLocationManager alloc] init];
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
    NSLog( error.localizedDescription );
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
    self.mapGMSMapView = [GMSMapView mapWithFrame:CGRectMake(10,
                                                             self.timePicker.frame.size.height + self.timePicker.frame.origin.y,
                                                             screenWidth - 20,
                                                             screenHeight - (self.timePicker.frame.origin.y + self.timePicker.frame.size.height))
                                           camera:camera];
    
    self.mapGMSMapView.camera = camera;
    self.mapGMSMapView.delegate = self;
    self.mapGMSMapView.myLocationEnabled = YES;
    
    [self.view addSubview:self.mapGMSMapView];
    
    self.marker = [[GMSMarker alloc] init];
    self.marker.position = CLLocationCoordinate2DMake(34.0203056, -118.2886556);
    self.marker.draggable = YES;
    self.marker.icon = [UIImage imageNamed:@"gmPin"];
    self.marker.map = self.mapGMSMapView;
}

- (void) mapView:(GMSMapView *)mapView didDraggMarker:(GMSMarker *)marker{
    [self.mapGMSMapView setCamera:[[GMSCameraPosition alloc] initWithTarget:marker.position zoom:16 bearing:mapView.camera.bearing viewingAngle:mapView.camera.viewingAngle]];
}

- (void) viewDidLoad{
    self.timesAvailable = @[@"15", @"30", @"45", @"60", @"90", @"120", @"150"];
    self.dogs = @[@"Sully", @"Max", @"Snowpuff", @"Diamond"];
    
    [self createPicker];
    [self createTable];
    [self locationSetup];
    [self googleMapsSampleSetup];
    
    self.navigationItem.title = @"Walk";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(startWalk)];
}

- (void) createTable{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height + 5, self.view.frame.size.width - 20, 20)];
    label.text = @"Which dogs are you walking?";
    
    [self.view addSubview:label];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, label.frame.origin.y + label.frame.size.height, self.view.frame.size.width, self.timePicker.frame.origin.y - label.frame.origin.y - 5) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Dogs Owned Cell"];
    
    [self.view addSubview:self.table];
}

- (void) createPicker{
    self.timePicker = [[UIPickerView alloc] init];
    self.timePicker.frame = CGRectMake(100, 180, 110, 80);
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    
    UILabel *outView = [[UILabel alloc] init];
    outView.frame = CGRectMake(20, 209, 72, 21);
    outView.text = @"Out for:";
    
    UILabel *time = [[UILabel alloc] init];
    time.text = @"minutes";
    time.textAlignment = NSTextAlignmentRight;
    time.frame = CGRectMake(215, 209, 72, 21);
    
    [self.view addSubview:self.timePicker];
    [self.view addSubview:time];
    [self.view addSubview:outView];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (section == 0 ? [self.dogs count] : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Dogs Owned Cell"];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Dogs Owned Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    //TODO FILL CELL
    cell.textLabel.text = [self.dogs objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
        NSLog(@"Checked");
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        NSLog(@"not checked");
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.timesAvailable objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.timeDifference = (NSUInteger) [self.timesAvailable objectAtIndex:row];
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.timesAvailable count];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (void) startWalk{

//    {
//        "operation": "create",
//        "TableName": "MapMarker",
//        "Item": {
//            "ID":
//            "dognames":[],
//            "lat": "",
//            "long": "",
//            "endTime":"",
//        }
//    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    [dict setObject:@"create" forKey:@"operation"];
    [dict setObject:@"MapMarker" forKey:@"TableName"];

    NSMutableArray *chosenDogs = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.dogs count]; ++i){
        NSIndexPath *index = [[NSIndexPath alloc] initWithIndex:i];
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:index];

        if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
            [chosenDogs addObject:cell.textLabel.text];
        }
    }

    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *todaysDate;
    todaysDate = [NSDate date];
    NSLog(@"Todays date is %@",[formatter stringFromDate:todaysDate]);
    NSString * stringDate = [formatter stringFromDate:todaysDate];


    AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
    [[lambdaInvoker invokeFunction:@"arn:aws:lambda:us-east-1:672822236713:function:HackSCTest2"
                        JSONObject:@{/*TODO CHANGE THIS*/}] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
        }
        if (task.result) {
            NSLog(@"Result: %@", task.result);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tabBarController.hidesBottomBarWhenPushed = NO;
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        return nil;
    }];

}

@end