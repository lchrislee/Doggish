//
//  WBDAddDogViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/15/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDAddDogViewController.h"
#import <Parse/Parse.h>
#import "Dog.h"
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
    [self.scrollView targetForAction:@selector(sizeValueChanged) withSender:self];
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
    Dog *d = [Dog object];
    
    d[@"Name"] = self.dogName.text;
    d[@"Breed"] = self.dogBreed.text;
    d[@"Favorite"] = self.favoriteDogField.text;
    d[@"About"] = self.aboutDogField.text;
    d[@"Age"] = @([self.dogAgeField.text integerValue] % 5);
    d[@"Rating"] = @0;
    d[@"Size"] = @(self.sliderSize.value);
//    d[@"Owner"] = [PFUser currentUser];
    d[@"Image"] = [PFFile fileWithName:[NSString stringWithFormat:@"%@_image.png", self.dogName.text]
                                  data:UIImagePNGRepresentation(self.dogImageButton.imageView.image)];
    
    [d saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog([error localizedDescription]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Could not save"
                                                                                     message:@"Please try to save your dog again."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {}]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
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
