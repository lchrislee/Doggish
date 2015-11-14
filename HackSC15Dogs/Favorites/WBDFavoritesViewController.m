//
//  WBDFavoritesViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDFavoritesViewController.h"

@interface WBDFavoritesViewController ()
@property (strong, nonatomic) UISegmentedControl *typeSelect;
@end

@implementation WBDFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.typeSelect = [[UISegmentedControl alloc] initWithItems:@[@"friends", @"dogs"]];
    self.typeSelect.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    [self.view addSubview:self.typeSelect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
