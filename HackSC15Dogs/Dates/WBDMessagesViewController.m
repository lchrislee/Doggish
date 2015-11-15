//
//  WBDDatesViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDMessagesViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>

@interface WBDMessagesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableArray *dates;
@end

@implementation WBDMessagesViewController

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return (section == 0 ? [self.dates count] : 0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void) createNSDictionaryTestData{
    NSDictionary* d = @{
                        @"mainTitleKey" : @"Andy",
                        @"secondaryTitleKey" : @"Hi there!",
                        @"imageKey" : @"stockChatPicture",
                        };

    NSDictionary* d2 = @{
                         @"mainTitleKey" : @"BAndy",
                         @"secondaryTitleKey" : @"Hi there!",
                         @"imageKey" : @"stockChatPicture",
                         };
    self.dates = [NSArray arrayWithObjects: d, d2, nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //Chris code for facebook
    /*if ([FBSDKAccessToken currentAccessToken]){

     }else{
     FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];

     [loginManager logInWithReadPermissions:@[@"public_profile", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
     if (error){
     NSLog(@"could not login");
     }
     else{
     [self pullMessages];
     }
     }];
     }
     */
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Message Cell" forIndexPath:indexPath];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Message Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *item = (NSDictionary *)[self.dates objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"mainTitleKey"];
    cell.detailTextLabel.text = [item objectForKey:@"secondaryTitleKey"];
    NSString *path = [[NSBundle mainBundle] pathForResource:[item objectForKey:@"imageKey"] ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
    return cell;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNSDictionaryTestData];
    [self.view addSubview:self.table];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)messages{
    if (!_dates){
        _dates = [[NSMutableArray alloc] init];
    }
    return _dates;
}

- (UITableView *)table{
    if (!_table){
        _table = [[UITableView alloc] initWithFrame:self.view.frame
                                              style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Message Cell"];
        _table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    return _table;
}

//Alternating background color of cells
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
        cell.backgroundColor = altCellColor;
    }
}

// I need to be able to call lambda functions
//    {
//    data:{
//        {
//            id:,
//        name:,
//        picture:
//            {
//            data:
//                {
//                    "is_silhouette": 0/1,
//                url:
//                }
//            };
//        }
//    };
//    paging:{
//    cursors:{
//    before:,
//    after:
//    };
//    };
//    }
//[self convertData: 4]
//[self storeFriendsData: 4 ];
//}
//
//
//-(void) sendFriendsData int: numFriends{
//    //I get data and
//    for( int i = 0; i < numFriends; i++){
//        [allItemsArray addObject:[NSNumber numberWithInt:i]];
//        NSDictionary * innerDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                          , @"name",
//                                          , @"imageUrl",
//                                          nil];
//        NSDictionary * item = [NSDictionary dictionaryWithObjectAndKeys:
//                               innerDictionary, @"Item", nil];
//        NSDictionary * event = [NSDictionary dictionaryWithObjectAndKeys:
//                                @"create", "operation",
//                                @"User", "TableName",
//                                item, @"Item", nil];
//
//        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:event
//                                                           options:(NSJSONWritingOptions)
//                            (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
//                                                             error:&error];
//
//        AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
//        //NSDictionary *parameters = @{@"operation" : @"ping",
//        [[lambdaInvoker invokeFunction:@"arn:aws:lambda:us-east-1:672822236713:function:HackSCTest2"
//                            JSONObject:jsonData] continueWithBlock:^id(AWSTask *task) {
//            if (task.error) {
//                NSLog(@"Error: %@", task.error);
//            }
//            if (task.exception) {
//                NSLog(@"Exception: %@", task.exception);
//            }
//            if (task.result) {
//                NSLog(@"Result: %@", task.result);
//                //don't need to do this because don't need return
//                //            dispatch_async(dispatch_get_main_queue(), ^{
//                //                NSError *error;
//                //                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:task.result
//                //                                                                         options:0 error:&error];
//                //                NSLog(@"%@", jsonDict);
//                //                //[self printOutputJSON:task.result];
//                //            });
//            }else{
//                NSLog(@"something else");
//            }
//            return nil;
//        }];
//    }
//    //    {
//    //        "operation": "create",
//    //        "TableName": "User",
//    //        "Item": {
//    //            "name":"1",
//    //            "imageUrl": "image URL 1"
//    //        }
//    //    }
//    //
//    //    {
//    //        "operation": "create",
//    //        "TableName": "User",
//    //        "Item": {
//    //            "name":"1",
//    //            "imageUrl": "image URL 1"
//    //        }
//    //    }
//}
@end
