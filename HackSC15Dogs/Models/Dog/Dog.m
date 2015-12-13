//
//  Dog.m
//  HackSC15Dogs
//
//  Created by Chris Lee on 12/13/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//
#import "Dog.h"
#import <Parse/PFObject+Subclass.h>

@interface Dog ()
@property (weak, nonatomic) PFUser *owner;
@end

@implementation Dog
@dynamic name;
@dynamic breed;
@dynamic favorite;
@dynamic about;
@dynamic age;
@dynamic rating;
@dynamic size;
@dynamic image;
@dynamic owner;

+(NSString *)parseClassName{
    return @"Dog";
}
@end