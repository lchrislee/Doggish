
//
//  PlayDate_PlayDate.h
//  HackSC15Dogs
//
//  Created by abc on 12/13/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#include <Parse/PFObject+Subclass.h>
#include "PlayDate.h"

@interface PlayDate ()

@end

@implementation PlayDate
@dynamic Walker;
@dynamic WalkingDogs;
@dynamic Location;
@dynamic Duration;

+(NSString *)parseClassName{
    return @"PlayDate";
}

@end