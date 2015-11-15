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

@interface WBDAWSCaller ()

@end

@implementation WBDAWSCaller

- (void)getLocalMarkersInDictionary:(SEL)callBack{
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
                [self performSelector:callBack withObject: result];
            });
        }
        return nil;
    }];
//    return 
}

@end