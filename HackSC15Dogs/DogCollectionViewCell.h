//
//  DogCollectionViewCell.h
//  HackSC15Dogs
//
//  Created by Ryan Zhou on 12/3/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DogCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *dogImage;
@property (weak, nonatomic) IBOutlet UILabel *dogName;

@end
