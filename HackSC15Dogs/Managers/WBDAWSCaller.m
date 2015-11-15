//
//  WBDAWSCaller.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDAWSCaller.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSLambda/AWSLambda.h>
#import "WBDHomeViewController.h"

@interface WBDAWSCaller ()

@end

@implementation WBDAWSCaller

- (void)getLocalMarkersInDictionary:(SEL)callBack
    WBDHomeViewController:controller{
    AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
    [[lambdaInvoker invokeFunction:@"arn:aws:lambda:us-east-1:672822236713:function:HackSCTest2"
                        JSONObject:@{@"operation":@"list", @"TableName":@"MapMarker", @"Limit":@3}] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
        }
        if (task.result) {
            NSLog(@"Result: %@", task.result);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                NSMutableDictionary *result = task.result;
//                NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:task.result options:NSJSONReadingMutableContainers error:&error];
                [controller performSelector:callBack withObject: result];
            });
        }
        return nil;
    }];
//    return 
}

-(void) pushNotifyUser{

//    {
//        "options":
//        {
//            "hostname": "gcm-http.googleapis.com",
//            "path":"/gcm/send",
//            "method": "POST",
//            "headers":{
//                "Content-Type":"application/json",
//                "Authorization":"key=AIzaSyAw8i7Mc0eOFCIFKUdihD5NQqaSNz7WEyo"
//            }
//        },
//        "data":
//        {
//            "to": "lxdKG7PDp04:APA91bH3_0CjaeoeNU8Mhq_2sTunmd_GRKJKN1QY3plWBWQutmn8x6vxIRyps3Z-ChXvcpNQYr1Qfug2UTRVfFGMKudwPKZ-dv-_EfkX4Tq5gqOqlYxL2awPL1WWlNpeqdG2DA35Wdqd",
//            "notification": {
//                "badge": "1",
//                "title": "Dog Request!",
//                "body": "X wants to meet you!"
//            }
//        }
//    }

    NSDictionary *innerDictionary =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"1", @"badge",
     @"Woof!", @"title",
     @"Someone wants to meet you!", @"body", nil];

    NSDictionary *notifAndToDictionary =
    [NSDictionary dictionaryWithObjectsAndKeys: innerDictionary, @"notification",
     @"l63HB_bDO0Q:APA91bEv4EO5lr9quvHVtaGVZ3ooRbUC-DKo57kKWujFyVmeLlHUO2hsf6cYJKjSsaqzWEWPgFd7LhoEuY9losCRahAdFGea2_DwTPasT7zYp1S4UeotHSD8m8NyhE7nOX4QkJUe9Ivx", @"to",
     nil];

    NSDictionary* innerHeadDictionary =
    [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"Content-type",
     @"key=AIzaSyAw8i7Mc0eOFCIFKUdihD5NQqaSNz7WEyo", @"Authorization", nil];

    NSDictionary* innerOptionsDictionary =
    [NSDictionary dictionaryWithObjectsAndKeys: @"gcm-http.googleapis.com", @"hostname",
     @"/gcm/send", @"path", @"POST", @"method", innerHeadDictionary, @"headers", nil];

    //do this last
    NSDictionary *overallDictionary =
    [NSDictionary dictionaryWithObjectsAndKeys:notifAndToDictionary, @"data",
     innerOptionsDictionary, @"options"
     ,nil];


    AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
    [[lambdaInvoker invokeFunction:@"arn:aws:lambda:us-east-1:672822236713:function:pushToDevice"
                        JSONObject: overallDictionary ] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
        }
        if (task.result) {
            NSLog(@"Result: %@", task.result);

            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                NSMutableDictionary *result = task.result;
                //                NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:task.result options:NSJSONReadingMutableContainers error:&error];
            });
        }
        return nil;
    }];

}

@end