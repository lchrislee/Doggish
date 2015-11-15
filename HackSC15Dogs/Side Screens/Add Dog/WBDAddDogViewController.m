//
//  WBDAddDogViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/15/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDAddDogViewController.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSLambda/AWSLambda.h>

@interface WBDAddDogViewController ()
@property (strong, nonatomic) UITextField *name;
@property (strong, nonatomic) UITextField *breed;
@property (strong, nonatomic) UISlider *sliderSize;
@property (strong, nonatomic) UISlider *sliderAge;
@end

@implementation WBDAddDogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.name = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, 80, 30)];
    [self.name setPlaceholder:@"Name"];
    
    [self.view addSubview:self.name];
    
    self.breed = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 80, 30)];
    [self.breed setPlaceholder:@"Dog Breed"];
    
    [self.view addSubview:self.breed];
    
    self.sliderSize = [[UISlider alloc] initWithFrame:CGRectMake(10, 125, self.view.frame.size.width - 40, 50)];
    
    self.sliderSize.minimumValueImage = [UIImage imageNamed:@"iconSizeMin.png"];
    self.sliderSize.maximumValueImage = [UIImage imageNamed:@"iconSizeMax.png"];
    self.sliderSize.maximumValue = 4;
    self.sliderSize.value = 2;
    [self.sliderSize addTarget:self action:@selector(sizeValueChanged) forControlEvents:UIControlEventValueChanged];
    
    self.sliderAge = [[UISlider alloc] initWithFrame:CGRectMake(10, 250, self.view.frame.size.width - 40, 50)];
    self.sliderAge.minimumValueImage = [UIImage imageNamed:@"iconAgeMin.png"];
    self.sliderAge.maximumValueImage = [UIImage imageNamed:@"iconAgeMax.png"];
    self.sliderAge.maximumValue = 4;
    self.sliderAge.value = 2;
    [self.sliderAge addTarget:self action:@selector(ageValueChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.sliderAge];
    [self.view addSubview:self.sliderSize];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveDog)];
}

- (void) saveDog{
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
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        return nil;
    }];
}

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

@end
