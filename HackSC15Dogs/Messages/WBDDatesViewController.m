//
//  WBDMessagesViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDDatesViewController.h"

@interface WBDDatesViewController ()
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableArray *messages;
@end

@implementation WBDDatesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //This is just an image, set it to the background image
//    NSString *imagePath = @"datesScreenBlurred";
//    NSString *path = [[NSBundle mainBundle] pathForResource:imagePath ofType:@"png"];
//    UIImage *theImage = [UIImage imageWithContentsOfFile:path];

    UIImageView *image =[[UIImageView alloc] initWithFrame:self.view.frame];
    image.image = [UIImage imageNamed:@"datesScreenBlurred"];
    [self.view addSubview:image];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
