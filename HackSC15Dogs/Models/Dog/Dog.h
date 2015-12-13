//
//  Dog.h
//  HackSC15Dogs
//
//  Created by Chris Lee on 12/13/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Dog : PFObject<PFSubclassing>
+(NSString *)parseClassName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *breed;
@property (strong, nonatomic) NSString *favorite;
@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSNumber *size;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic, readonly) PFUser *owner;

@end