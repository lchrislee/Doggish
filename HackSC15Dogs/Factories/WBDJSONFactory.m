//
//  WBDJSONFactory.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDJSONFactory.h"

@interface WBDJSONFactory ()
@property (strong, nonatomic) NSMutableDictionary *data;
@end

@implementation WBDJSONFactory

- (void) useKey:(NSString*)key forValue:(NSString*)value{
    [self.data setObject:value forKey:key];
}

- (void) removeKey:(NSString*)key{
    [self.data removeObjectForKey:key];
}

- (NSData *) getJSONData{
    NSError *error;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.data options:NSJSONWritingPrettyPrinted error:&error];
    if (!error){
        return data;
    }
    else
        return nil;
}

- (NSMutableDictionary *)data{
    if (!_data){
        _data = [[NSMutableDictionary alloc] init];
    }
    return _data;
}

@end