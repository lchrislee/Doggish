//
//  WBDWebProfileViewController.h
//  HackSC15Dogs
//
//  Created by Chris Lee on 12/13/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface WBDWebProfileViewController : UIViewController
@property (strong, nonatomic) PFUser *user;
@end
