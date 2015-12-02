//
//  WBDFavoritesViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDFavoritesViewController.h"

@interface WBDFavoritesViewController ()

@property (strong, nonatomic) UISegmentedControl *typeSelect;
@property (strong, nonatomic) AWSLambdaInvoker *lambdaInvoker;

@end

@implementation WBDFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
//    self.typeSelect = [[UISegmentedControl alloc] initWithItems:@[@"friends", @"dogs"]];
//    self.typeSelect.selectedSegmentIndex = 0;
//    self.typeSelect.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, 25);
//    [self.view addSubview:self.typeSelect];

//    [self sendPush];
    //[self createButton];
    [self.view addSubview:[[UIImageView alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"sampleSearchResult.png"] scaledToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)]]];
}

-(UIImage*)imageWithImage:(UIImage*)image
             scaledToSize:(CGSize)newsize{
    UIGraphicsBeginImageContext(newsize);
    [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createButton{
    UIButton *button = [[UIButton alloc] init];
//    [button addTarget:self
//               action:@selector(sendPush)
//     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"TEST LAMBDA" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 0.0, 160.0, 40.0);
    [self.view addSubview:button];
    //http://stackoverflow.com/questions/1378765/how-do-i-create-a-basic-uibutton-programmatically
}


//-(NSDictionary*) createSampleData{
//    NSDictionary *innerBodyDictionary =
//    [NSDictionary dictionaryWithObjectsAndKeys:
//     @"default", @"sound",
//     @"2", @"badge",
//     @"default", @"title",
//     @"Testpush!", @"body", nil];
//
//    NSDictionary *toDictionary =
//    [NSDictionary dictionaryWithObjectsAndKeys:
//     @"m7wesLWWSb8:APA91bHNM5CW4oaNWTT--phNQOUpbL64WrlYQu8jTevFCORl5NWiI7VD2GtVOwKiH-l2oWiJjRx0mwuqV4n1J9hDuT7maR3DmEtmmqleXPND6Z5cTsofk_UAWxhqhlXnf_FpAj8fnK-7", @"to", nil];
//
//    NSDictionary *bodyDictionary =
//    [NSDictionary dictionaryWithObjectsAndKeys:
//     innerBodyDictionary, @"notification",
//     toDictionary, @"to", nil];
//
//    NSDictionary *dataDictionary = @{@"data":bodyDictionary};
//    return dataDictionary;
//}
//-(void) sendPush{
//
//    NSDictionary* d = [self createSampleData];
//    NSLog(@"Testing lambda");
//    self.lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
//    //NSDictionary *parameters = @{@"operation" : @"ping",
//    [[self.lambdaInvoker invokeFunction:@"arn:aws:lambda:us-east-1:672822236713:function:pushToDevice"
//                             JSONObject:d] continueWithBlock:^id(AWSTask *task) {
//        if (task.error) {
//            NSLog(@"Error: %@", task.error);
//        }
//        if (task.exception) {
//            NSLog(@"Exception: %@", task.exception);
//        }
//        if (task.result) {
//            NSLog(@"Result: %@", task.result);
//            //YEA LOL, fix dis later
////            *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[__NSCFString bytes]: unrecognized selector sent to instance 0x1573adc0'
//
////            dispatch_async(dispatch_get_main_queue(), ^{
////                NSError *error;
////                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:task.result
////                                                                         options:0 error:&error];
////                NSLog(@"%@", jsonDict);
////                //[self printOutputJSON:task.result];
////            });
//        }else{
//            NSLog(@"something else");
//        }
//        return nil;
//    }];
//
//    //create dictionary body
//    //body
//    //    {
//    //        "to": "gcm_token_of_the_device",
//    //        "notification": {
//    //            "sound": "default",
//    //            "badge": "2",
//    //            "title": "default",
//    //            "body": "Test Push!"
//    //        }
//    //    }
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//}
@end
