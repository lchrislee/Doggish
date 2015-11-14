//
//  AppDelegate.h
//  HackSC15Dogs
//
//  Created by abc on 11/13/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, readonly, strong) NSString *registrationKey;

@property(nonatomic, readonly, strong) NSString *messageKey;

@property(nonatomic, readonly, strong) NSString *gcmSenderID;

@property(nonatomic, readonly, strong) NSDictionary *registrationOptions;

@end
