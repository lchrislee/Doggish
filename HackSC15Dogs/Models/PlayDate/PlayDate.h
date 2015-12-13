//
//  PlayDate.h
//  HackSC15Dogs
//
//  Created by Chris Lee on 12/13/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PlayDate : PFObject<PFSubclassing>
+(NSString *)parseClassName;
@property (strong, nonatomic) NSNumber *Duration;
@property (strong, nonatomic) PFGeoPoint *Location;
@property (strong, nonatomic) NSArray *WalkingDogs;
@property (weak, nonatomic) PFUser *Walker;
@end
