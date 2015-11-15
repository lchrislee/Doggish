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

@interface WBDLoginScreenController () <FBSDKLoginButtonDelegate>
@property (strong, nonatomic) FBSDKLoginButton *loginButton;
@end

@implementation WBDLoginScreenController

- (void) viewDidLoad{
    if (![FBSDKAccessToken currentAccessToken]){
        NSLog(@"no access token");
        self.loginButton = [[FBSDKLoginButton alloc] init];
        self.loginButton.readPermissions = @[@"user_friends",@"public_profile"];
        
        self.loginButton.center = self.view.center;
        
        [self.view addSubview:self.loginButton];
    }else{
        NSLog(@"Access token");
        [self transition];
    }
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    if (!error){
        NSLog(@"login good");
        [self transition];
    }
    else{
        NSLog(@"ERROR: %@", [error localizedDescription]);
    }
}

- (void) transition{
    NSLog(@"Transition");
//    [self presentViewController:[[self.tabBar viewControllers] objectAtIndex:0] animated:YES completion:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[self.tabBar selectedViewController] animated:YES completion:nil];
}

@end
