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
#import "DogCollectionViewCell.h"
#import "Dog.h"

@interface WBDProfileViewController ()
@property (strong, nonatomic) NSMutableArray *dogs;
@end

@implementation WBDProfileViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    if (self.userToDisplay == nil){
        self.userToDisplay = [PFUser currentUser];
    }
    
    [self.userToDisplay fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.dogs = self.userToDisplay[@"Dogs"];
        [_collectionView reloadData];
    }];
}

- (void) navigationSetup{
    self.navigationItem.title = @"Dogs";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDog)];
    self.navigationItem.title = @"Your Dogs";
    
    self.navigationItem.leftBarButtonItem = [self createUIBarButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationSetup];
    
    //self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];

    // Register this NIB which contains the cell
    UINib *nib = [UINib nibWithNibName:@"CustomCollectionView" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"DogCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(UIBarButtonItem*) createUIBarButton{

    //Create a button
    UIImage *image = [UIImage imageNamed:@"logout"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(facebookLogout) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void) facebookLogout{
    [[FBSDKLoginManager new] logOut];
    [PFUser logOut];
    self.userToDisplay = nil;
    [self.tabBarController setSelectedIndex:0];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DogCollectionViewCell *cell = (DogCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DogCell" forIndexPath:indexPath];
    
    int sum = 0;
    for (int i = 0; i < indexPath.length; ++i){
        sum += [indexPath indexAtPosition:i];
    }
    
    Dog *d = [self.dogs objectAtIndex:sum];
    [d fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        cell.dogImage.image = [UIImage imageWithData:[((PFFile *)d[@"Image"]) getData]];
        cell.dogName = d[@"Name"];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }];
    
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.userToDisplay[@"Dogs"] count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0; // spacing between cells
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //allows for 2 cells in each row
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width/2);
}


- (void) addDog{
    for (UIView *v in [self.view subviews]){
        if ([v isKindOfClass:[FBSDKLoginButton class]]){
            [v removeFromSuperview];
        }
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"DogAdd"] animated:YES];
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
