//
//  WBDWebProfileViewController.m
//  HackSC15Dogs
//
//  Created by Chris Lee on 12/13/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDWebProfileViewController.h"
#import <WebKit/WebKit.h>

@interface WBDWebProfileViewController ()<WKNavigationDelegate>

@end

@implementation WBDWebProfileViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:[[WKWebViewConfiguration alloc] init]];
    webView.navigationDelegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlToDisplay]]];
    self.view = webView;
}

@end
