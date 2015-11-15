//
//  WBDJSONFactory.h
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBDJSONFactory : NSObject

- (void) useKey:(NSString*)key forValue:(NSString*)value;
- (NSData *) getJSONData;
- (void) removeKey:(NSString*)key;
@end
