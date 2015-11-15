//
//  AppDelegate.m
//  HackSC15Dogs
//
//  Created by abc on 11/13/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Google/CloudMessaging.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "WBDMessagesViewController.h"
#import "WBDDatesViewController.h"
#import "WBDFavoritesViewController.h"
#import "WBDHomeViewController.h"
#import "WBDProfileViewController.h"

#import "WBDFilterViewController.h"

@import GoogleMaps;
@interface AppDelegate ()
// FOR GCM
@property(nonatomic, strong) void (^registrationHandler)
(NSString *registrationToken, NSError *error);
@property(nonatomic, assign) BOOL connectedToGCM;
@property(nonatomic, strong) NSString* registrationToken;
@property(nonatomic, assign) BOOL subscribedToTopic;

@property(strong, nonatomic) UITabBarController *tabController;
@end

NSString *const SubscriptionTopic = @"/topics/global";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerRemoteNotifications];
    [self startGCMStuff];
    [GMSServices provideAPIKey:@"AIzaSyCjXLKN4rzvyXk87PksMiPn5OJBESEAp6E"];
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.tabController = [[UITabBarController alloc] init];
    self.tabController.hidesBottomBarWhenPushed = NO;
    
    self.tabController.viewControllers = @[[self makeHomeController],
                                           [self makeMessagesController],
                                           [self makeDatesController],
                                           [self makeFavoritesController],
                                           [self makeProfileController]
                                           ];
    self.tabController.selectedIndex = 0;
    
    self.window.rootViewController = self.tabController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UINavigationController *)makeHomeController{
    WBDHomeViewController *homeView = [[WBDHomeViewController alloc] init];
    homeView.title = @"Find Dogs";
    
    UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:homeView];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Find Dogs" image:[UIImage imageNamed:@"iconHome.png"] tag:0];
//    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:homeView action:[WBDHomeViewController getFilterSelector]];
    return viewController;
}

- (UINavigationController *)makeFavoritesController{
    WBDFavoritesViewController *favoritesView = [[WBDFavoritesViewController alloc] init];
    favoritesView.title = @"Favorites";
    
    UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:favoritesView];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favorites" image:[UIImage imageNamed:@"iconFavorite.png"] tag:0];
    return viewController;
}

- (UINavigationController *)makeDatesController{
    WBDFilterViewController *dateView = [[WBDFilterViewController alloc] init];
    dateView.title = @"Dates";
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:dateView];
    navController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Dates" image:[UIImage imageNamed:@"iconDate.png"] tag:0];
    return navController;
}

- (UINavigationController *)makeMessagesController{
    WBDMessagesViewController *messageView = [[WBDMessagesViewController alloc] init];
    messageView.title = @"Messages";
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageView];
    navController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Messages" image:[UIImage imageNamed:@"iconChat.png"] tag:0];
    return navController;
}

- (UINavigationController *)makeProfileController{
    WBDProfileViewController *profileView = [[WBDProfileViewController alloc] init];
    profileView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"iconProfile"] tag:0];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:profileView];
    return navController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[GCMService sharedInstance] disconnect];
    // [START_EXCLUDE]
    _connectedToGCM = NO;
    // [END_EXCLUDE]
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    [[GCMService sharedInstance] connectWithHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Could not connect to GCM: %@", error.localizedDescription);
        } else {
            _connectedToGCM = true;
            NSLog(@"Connected to GCM");
            // [START_EXCLUDE]
            [self subscribeToTopic];
            // [END_EXCLUDE]
        }
    }];
}

- (void)subscribeToTopic {
    // If the app has a registration token and is connected to GCM, proceed to subscribe to the
    // topic
    if (_registrationToken && _connectedToGCM) {
        [[GCMPubSub sharedInstance] subscribeWithToken:_registrationToken
                                                 topic:SubscriptionTopic
                                               options:nil
                                               handler:^(NSError *error) {
                                                   if (error) {
                                                       // Treat the "already subscribed" error more gently
                                                       if (error.code == 3001) {
                                                           NSLog(@"Already subscribed to %@",
                                                                 SubscriptionTopic);
                                                       } else {
                                                           NSLog(@"Subscription failed: %@",
                                                                 error.localizedDescription);
                                                       }
                                                   } else {
                                                       self.subscribedToTopic = true;
                                                       NSLog(@"Subscribed to %@", SubscriptionTopic);
                                                   }
                                               }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void) registerRemoteNotifications{
    UIUserNotificationType allNotificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void) startGCMStuff{
    GCMConfig *gcmConfig = [GCMConfig defaultConfig];
    gcmConfig.receiverDelegate = self;
    [[GCMService sharedInstance] startWithConfig:gcmConfig];
    // [END start_gcm_service]
    __weak typeof(self) weakSelf = self;
    // Handler for registration token request
    _registrationHandler = ^(NSString *registrationToken, NSError *error){
        if (registrationToken != nil) {
            weakSelf.registrationToken = registrationToken;
            NSLog(@"Registration Token: %@", registrationToken);
            [weakSelf subscribeToTopic];
            NSDictionary *userInfo = @{@"registrationToken":registrationToken};
            [[NSNotificationCenter defaultCenter] postNotificationName:weakSelf.registrationKey
                                                                object:nil
                                                              userInfo:userInfo];
        } else {
            NSLog(@"Registration to GCM failed with error: %@", error.localizedDescription);
            NSDictionary *userInfo = @{@"error":error.localizedDescription};
            [[NSNotificationCenter defaultCenter] postNotificationName:weakSelf.registrationKey
                                                                object:nil
                                                              userInfo:userInfo];
        }
    };
}

// [START receive_apns_token]
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // [END receive_apns_token]
    // [START get_gcm_reg_token]
    // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
    GGLInstanceIDConfig *instanceIDConfig = [GGLInstanceIDConfig defaultConfig];
    instanceIDConfig.delegate = self;
    // Start the GGLInstanceID shared instance with the that config and request a registration
    // token to enable reception of notifications
    [[GGLInstanceID sharedInstance] startWithConfig:instanceIDConfig];
    _registrationOptions = @{kGGLInstanceIDRegisterAPNSOption:deviceToken,
                             kGGLInstanceIDAPNSServerTypeSandboxOption:@YES};
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
    NSLog(@"Token: %@", _gcmSenderID);
    // [END get_gcm_reg_token]
}

// [START receive_apns_token_error]
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registration for remote notification failed with error: %@", error.localizedDescription);
    // [END receive_apns_token_error]
    NSDictionary *userInfo = @{@"error" :error.localizedDescription};
    [[NSNotificationCenter defaultCenter] postNotificationName:_registrationKey
                                                        object:nil
                                                      userInfo:userInfo];
}

// [START ack_message_reception]
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Notification received: %@", userInfo);
    // This works only if the app started the GCM service
    [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    // Handle the received message
    // [START_EXCLUDE]
    [[NSNotificationCenter defaultCenter] postNotificationName:_messageKey
                                                        object:nil
                                                      userInfo:userInfo];
    // [END_EXCLUDE]
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
    NSLog(@"Notification received: %@", userInfo);
    // This works only if the app started the GCM service
    [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    // Handle the received message
    // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
    // [START_EXCLUDE]
    [[NSNotificationCenter defaultCenter] postNotificationName:_messageKey
                                                        object:nil
                                                      userInfo:userInfo];
    handler(UIBackgroundFetchResultNoData);
    // [END_EXCLUDE]
}
// [END ack_message_reception]

// [START on_token_refresh]
- (void)onTokenRefresh {
    // A rotation of the registration tokens is happening, so the app needs to request a new token.
    NSLog(@"The GCM registration token needs to be changed.");
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
}
// [END on_token_refresh]

// [START upstream_callbacks]
- (void)willSendDataMessageWithID:(NSString *)messageID error:(NSError *)error {
    if (error) {
        // Failed to send the message.
    } else {
        // Will send message, you can save the messageID to track the message
    }
}

- (void)didSendDataMessageWithID:(NSString *)messageID {
    // Did successfully send message identified by messageID
}
// [END upstream_callbacks]

- (void)didDeleteMessagesOnServer {
    // Some messages sent to this device were deleted on the GCM server before reception, likely
    // because the TTL expired. The client should notify the app server of this, so that the app
    // server can resend those messages.
}

@end
