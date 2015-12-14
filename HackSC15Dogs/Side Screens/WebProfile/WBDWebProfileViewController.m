//
//  WBDWebProfileViewController.m
//  HackSC15Dogs
//
//  Created by Chris Lee on 12/13/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDWebProfileViewController.h"
#import "WBDProfileViewController.h"
#import "WBDWalkingViewController.h"
#import <WebKit/WebKit.h>

@interface WBDWebProfileViewController ()<WKNavigationDelegate>

@end

@implementation WBDWebProfileViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self setUpNavigation];
    
    [self setUpWebView];
}

- (void) setUpNavigation{
    UIBarButtonItem *meet = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"meetingRequest"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(goToDate)];
    
    UIBarButtonItem *dogs = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconDogFace"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(displayDogs)];
    self.navigationItem.rightBarButtonItems = @[meet, dogs];
}

- (void) setUpWebView{
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:[[WKWebViewConfiguration alloc] init]];
    webView.navigationDelegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:(self.user[@"Url"])]]];
    self.view = webView;
}

- (void) displayDogs{
    WBDProfileViewController *vc = [[WBDProfileViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) goToDate{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    WBDWalkingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WalkViewController"];
    vc.date = self.user[@"CurrentDate"];
    [vc.date fetchIfNeeded];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
