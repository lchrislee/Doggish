//
//  WBDProfileViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDProfileViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "WBDAddDogViewController.h"
@interface WBDProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableDictionary *dogs;
@end

@implementation WBDProfileViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [self.dogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //reusing
    //NSIndexpath = describe section and row
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Dog Cell"];
    //see if there is a cell we can reuse
    
    if (cell == nil) {
        //if no identifier, create one
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Dog Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // TODO FILL CELL
    return cell;
}

//Alternating background color of cells
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
        cell.backgroundColor = altCellColor;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    [self testFacebookLogin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Dogs";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDog)];
    self.navigationItem.title = @"Your Dogs";
    self.table = [[UITableView alloc] init];
    self.table.contentInset = UIEdgeInsetsMake(0, self.navigationController.navigationBar.frame.size.height, 0, 0);
    [self.view addSubview: self.table];
}

-(void) testFacebookLogin{
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    // request to see friends
    loginButton.readPermissions = @[@"user_friends"];
    [self.view addSubview:loginButton];
}

- (void) addDog{
    for (UIView *v in [self.view subviews]){
        if ([v isKindOfClass:[FBSDKLoginButton class]]){
            [v removeFromSuperview];
        }
    }
    
    [self.navigationController pushViewController:[[WBDAddDogViewController alloc] init] animated:YES];
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
