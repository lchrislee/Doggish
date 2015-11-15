//
//  WBDFilterViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDFilterViewController.h"

@interface WBDFilterViewController () <UISearchBarDelegate>
@property (strong, nonatomic) UISlider *sliderSize;
@property (strong, nonatomic) UISlider *sliderAge;

@property (strong, nonatomic) UISearchBar *searchBreedName;
@end

@implementation WBDFilterViewController

-(void) ageValueChanged{
    int bottom = self.sliderAge.value;
    int top = self.sliderAge.value + 0.5;
    
    if (top == bottom){
        [self.sliderAge setValue:bottom animated:YES];
    }else{
        [self.sliderAge setValue:top animated:YES];
    }
}

-(void) sizeValueChanged{
    int bottom = self.sliderSize.value;
    int top = self.sliderSize.value + 0.5;
    
    if (top == bottom){
        [self.sliderSize setValue:bottom animated:YES];
    }else{
        [self.sliderSize setValue:top animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sliderSize = [[UISlider alloc] initWithFrame:CGRectMake(10, 225, self.view.frame.size.width - 40, 50)];

//    UIImage *clearImage = [[UIImage imageNamed:@"searchBar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
//    [self.sliderSize setMinimumTrackImage:clearImage forState:UIControlStateNormal];
//    [self.sliderSize setMaximumTrackImage:clearImage forState:UIControlStateNormal];
    
    self.sliderSize.minimumValueImage = [UIImage imageNamed:@"iconSizeMin.png"];
    self.sliderSize.maximumValueImage = [UIImage imageNamed:@"iconSizeMax.png"];
    self.sliderSize.maximumValue = 4;
    self.sliderSize.value = 2;
    [self.sliderSize addTarget:self action:@selector(sizeValueChanged) forControlEvents:UIControlEventValueChanged];
    
    self.sliderAge = [[UISlider alloc] initWithFrame:CGRectMake(10, 350, self.view.frame.size.width - 40, 50)];
    self.sliderAge.minimumValueImage = [UIImage imageNamed:@"iconAgeMin.png"];
    self.sliderAge.maximumValueImage = [UIImage imageNamed:@"iconAgeMax.png"];
    self.sliderAge.maximumValue = 4;
    self.sliderAge.value = 2;
    [self.sliderAge addTarget:self action:@selector(ageValueChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.sliderAge];
    [self.view addSubview:self.sliderSize];
    
    self.searchBreedName = [[UISearchBar alloc] init];
    self.searchBreedName.delegate = self;
    self.searchBreedName.placeholder = @"Search by breed";
    [self.searchBreedName becomeFirstResponder];
    [self.searchBreedName resignFirstResponder];
    
    self.navigationItem.titleView = self.searchBreedName;
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
