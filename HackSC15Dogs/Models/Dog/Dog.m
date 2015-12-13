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

@end

@implementation Dog
@dynamic Name;
@dynamic Breed;
@dynamic Favorite;
@dynamic About;
@dynamic Age;
@dynamic Rating;
@dynamic Size;
@dynamic Image;
@dynamic Owner;

+(NSString *)parseClassName{
    return @"Dog";
}

- (UIImage *) getImage{
    return [UIImage imageWithData:[self[@"Image"] getData]];
}

@end