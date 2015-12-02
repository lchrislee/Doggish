//
//  WBDAddDogViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/15/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDAddDogViewController.h"
//#import <AWSCore/AWSCore.h>
//#import <AWSCognito/AWSCognito.h>
//#import <AWSLambda/AWSLambda.h>

@interface WBDAddDogViewController () <UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UITextField *name;
@property (strong, nonatomic) UITextField *breed;
@property (strong, nonatomic) UISlider *sliderSize;
@property (strong, nonatomic) UISlider *sliderAge;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@end

@implementation WBDAddDogViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.name = [[UITextField alloc] initWithFrame:CGRectMake(30, 210, 80, 30)];
    [self.name setPlaceholder:@"Name"];
    
    [self.view addSubview:self.name];
    
    self.breed = [[UITextField alloc] initWithFrame:CGRectMake(30, 260, 100, 30)];
    [self.breed setPlaceholder:@"Dog Breed"];
    
    [self.view addSubview:self.breed];
    
    self.sliderSize = [[UISlider alloc] initWithFrame:CGRectMake(10, 335, self.view.frame.size.width - 30, 50)];
    
    self.sliderSize.minimumValueImage = [UIImage imageNamed:@"iconSizeMin.png"];
    self.sliderSize.maximumValueImage = [UIImage imageNamed:@"iconSizeMax.png"];
    self.sliderSize.maximumValue = 4;
    self.sliderSize.value = 2;
    [self.sliderSize addTarget:self action:@selector(sizeValueChanged) forControlEvents:UIControlEventValueChanged];
    
    self.sliderAge = [[UISlider alloc] initWithFrame:CGRectMake(10, 420, self.view.frame.size.width - 30, 50)];
    self.sliderAge.minimumValueImage = [UIImage imageNamed:@"iconAgeMin.png"];
    self.sliderAge.maximumValueImage = [UIImage imageNamed:@"iconAgeMax.png"];
    self.sliderAge.maximumValue = 4;
    self.sliderAge.value = 2;
    [self.sliderAge addTarget:self action:@selector(ageValueChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.sliderAge];
    [self.view addSubview:self.sliderSize];
    
    self.navigationItem.title = @"Traits";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveDog)];
    
    self.image = [[UIImageView alloc] init];
    self.image.center = CGPointMake(30, self.navigationController.navigationBar.frame.size.height + 30);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"Add image" forState:UIControlStateNormal];
    button.frame = CGRectMake(150, self.navigationController.navigationBar.frame.size.height + 30, 100, 100);
    [button addTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
    
    [self.view addSubview:self.image];
    
//    [self addImagePicker];
}

//- (void) saveDog{
//    AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
//    [[lambdaInvoker invokeFunction:@"arn:aws:lambda:us-east-1:672822236713:function:HackSCTest2"
//                        JSONObject:@{/*TODO CHANGE THIS*/}] continueWithBlock:^id(AWSTask *task) {
//        if (task.error) {
//            NSLog(@"Error: %@", task.error);
//        }
//        if (task.exception) {
//            NSLog(@"Exception: %@", task.exception);
//        }
//        if (task.result) {
//            NSLog(@"Result: %@", task.result);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }
//        return nil;
//    }];
//}

-(void) ageValueChanged{
    int bottom = self.sliderAge.value;
    int top = self.sliderAge.value + 0.5;
    
    if (top == bottom){
        [self.sliderAge setValue:bottom animated:YES];
    }else{
        [self.sliderAge setValue:top animated:YES];
    }
}

-(void) sizeValueChanged{
    int bottom = self.sliderSize.value;
    int top = self.sliderSize.value + 0.5;
    
    if (top == bottom){
        [self.sliderSize setValue:bottom animated:YES];
    }else{
        [self.sliderSize setValue:top animated:YES];
    }
}

//- (void )addImagePicker{
//    self.imagePicker = [[UIImagePickerController alloc] init];
//    self.imagePicker.allowsEditing = NO;
//    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    self.imagePicker.delegate = self;
//    self.imagePicker.mediaTypes =
//    [UIImagePickerController availableMediaTypesForSourceType:
//     UIImagePickerControllerSourceTypeCamera];
//}
//
//- (void) showCamera{
////    [self.navigationController pushViewController:self.imagePicker animated:YES];
//    [self.imagePicker takePicture];
//}
//
//- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    UIImage *originalImage, *editedImage, *imageToSave;
//    
//    // Handle a still image capture
//    editedImage = (UIImage *) [info objectForKey:
//                               UIImagePickerControllerEditedImage];
//    originalImage = (UIImage *) [info objectForKey:
//                                 UIImagePickerControllerOriginalImage];
//    
//    if (editedImage) {
//        imageToSave = editedImage;
//    } else {
//        imageToSave = originalImage;
//    }
//    
//    // Save the new image (original or edited) to the Camera Roll
//    UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
//    
//    self.image.image = imageToSave;
//    
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    picker = nil;
//}
//
//- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    picker = nil;
//}

@end
