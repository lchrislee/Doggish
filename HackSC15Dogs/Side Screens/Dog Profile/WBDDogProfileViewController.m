//
//  WBDDogrofileViewController.m
//  HackSC15Dogs
//
//  Created by Chris Lee on 12/1/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDDogProfileViewController.h"
#import "WBDWebProfileViewController.h"
#import <WebKit/WebKit.h>

@interface WBDDogProfileViewController () <WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *dogImage;
@property (weak, nonatomic) IBOutlet UIButton *humanImage;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *humanNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dogBreedLabel;
@property (weak, nonatomic) IBOutlet UITextView *dogAboutTextView;
@property (weak, nonatomic) IBOutlet UITextView *dogFavoriteTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation WBDDogProfileViewController

- (void) setUpHuman{
    self.humanImage.layer.cornerRadius = self.humanImage.frame.size.width / 2;
    self.humanImage.layer.masksToBounds = YES;
    self.humanImage.layer.borderWidth = 2.0f;
    
    NSString *urlString = self.user[@"Image"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    self.humanImage.imageView.image = [UIImage imageWithData:imageData];
}

- (void) fixDogImage{
    self.scrollView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0);
}

- (void) setNavItems{
    self.navigationItem.title = self.dog[@"Name"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1.13 green:0.81 blue:0.34 alpha:1.0]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.dog fetch];
    if (self.user == nil){
        self.user = [PFUser currentUser];
    }
    [self.user fetch];
    
    [self setNavItems];
    
    self.ratingLabel.hidden = YES;
    self.humanNameLabel.text = [NSString stringWithFormat:@"%@'s",(self.user[@"Name"])];
    self.dogBreedLabel.text = self.dog[@"Breed"];
    self.dogFavoriteTextView.text = self.dog[@"Favorite"];
    self.dogAboutTextView.text = self.dog[@"About"];
    
    PFFile *dogImage = self.dog[@"Image"];
    self.dogImage.image = [UIImage imageWithData:[dogImage getData]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpHuman];
    [self fixDogImage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = nil;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) message{
    
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
