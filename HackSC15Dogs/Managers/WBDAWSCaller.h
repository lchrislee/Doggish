//
//  WBDAWSCaller.h
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBDAWSCaller : NSObject

- (void)getLocalMarkersInDictionary:(SEL)callBack;
-(void) pushNotifyUser;

@end