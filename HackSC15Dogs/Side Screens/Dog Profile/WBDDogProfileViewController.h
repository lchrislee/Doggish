//
//  WBDDogrofileViewController.h
//  HackSC15Dogs
//
//  Created by Chris Lee on 12/1/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dog.h"
#import <Parse/Parse.h>

@interface WBDDogProfileViewController : UIViewController
@property (strong, nonatomic) Dog *dog;
@property (strong, nonatomic) PFUser *user;
@end
