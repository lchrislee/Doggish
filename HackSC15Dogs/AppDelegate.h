//
//  AppDelegate.h
//  HackSC15Dogs
//
//  Created by abc on 11/13/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSCore/AWSCore.h>
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
#import <AWSDynamoDB/AWSDynamoDB.h>
#import <AWSSQS/AWSSQS.h>
#import <AWSSNS/AWSSNS.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSLambda/AWSLambda.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, readonly, strong) NSString *registrationKey;

@property(nonatomic, readonly, strong) NSString *messageKey;

@property(nonatomic, readonly, strong) NSString *gcmSenderID;

@property(nonatomic, readonly, strong) NSDictionary *registrationOptions;
@property(strong, nonatomic) NSString *GLOBAL_SCOPE_FACEBOOK_ID;

@end

