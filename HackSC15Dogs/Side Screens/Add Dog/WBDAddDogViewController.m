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

@interface WBDAddDogViewController ()
@property (weak, nonatomic) IBOutlet UIButton *dogImageButton;
@property (weak, nonatomic) IBOutlet UITextField *aboutDogField;
@property (weak, nonatomic) IBOutlet UITextField *favoriteDogField;
@property (weak, nonatomic) IBOutlet UITextField *dogAgeField;
@property (weak, nonatomic) IBOutlet UISlider *sliderSize;
@property (weak, nonatomic) IBOutlet UITextField *dogName;
@property (weak, nonatomic) IBOutlet UITextField *dogBreed;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation WBDAddDogViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Add Dog";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveDog)];
    self.scrollView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0);
}

- (IBAction)dogImageUpdate:(id)sender {
    
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

- (void) saveDog{
    [self.navigationController popViewControllerAnimated:YES];
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
