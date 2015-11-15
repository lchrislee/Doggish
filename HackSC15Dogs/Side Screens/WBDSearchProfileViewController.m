//
//  WBDSearchProfileViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDSearchProfileViewController.h"
#import "WBDAWSCaller.h"

@interface WBDSearchProfileViewController ()
@end

@implementation WBDSearchProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"sampleProfileScreen.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)]];
    [self.view addSubview:imageView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Meet" style:UIBarButtonItemStylePlain target:self action:@selector(sendPush)];
}

-(void)sendPush{
    WBDAWSCaller *caller = [[WBDAWSCaller alloc] init];
    [caller pushNotifyUser];
}
                              
-(UIImage*)imageWithImage:(UIImage*)image
             scaledToSize:(CGSize)newsize{
    UIGraphicsBeginImageContext(newsize);
    [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
