//
//  WBDLoginScreenController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDLoginScreenController.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface WBDLoginScreenController ()
@property (strong, nonatomic) FBSDKLoginButton *loginButton;
@end

@implementation WBDLoginScreenController

- (void) viewDidLoad{
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.readPermissions = @[@"user_friends",@"public_profile"];
    
    self.loginButton.center = self.view.center;
    
    [self.view addSubview:self.loginButton];

}

@end
