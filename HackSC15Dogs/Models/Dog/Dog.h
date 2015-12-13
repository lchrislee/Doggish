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
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSString *Breed;
@property (strong, nonatomic) NSString *Favorite;
@property (strong, nonatomic) NSString *About;
@property (strong, nonatomic) NSNumber *Age;
@property (strong, nonatomic) NSNumber *Rating;
@property (strong, nonatomic) NSNumber *Size;
@property (strong, nonatomic) UIImage *Image;
@property (weak, nonatomic) PFUser *Owner;

@end