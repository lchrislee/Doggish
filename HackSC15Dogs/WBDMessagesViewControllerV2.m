//
//  WBDMessagesViewControllerV2.m
//  HackSC15Dogs
//
//  Created by Ryan Zhou on 11/15/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDMessagesViewControllerV2.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>



@implementation WBDMessagesViewControllerV2

-(void) viewDidLoad{

    [super viewDidLoad];
    NSLog( @"about to call facebook");
    [self facebookGetData];
    [self createTable];
    //[self createNSDictionaryTestData];
}

- (void) facebookGetData{
    if( [FBSDKAccessToken currentAccessToken] == nil){
        NSLog(@"its nill");
    }
    else{
        NSLog(@"its not");
    }
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_friends"]){
        // create a request to actually get the friends
        FBSDKGraphRequest * request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/friends?fields=name,picture"
                                                                        parameters:nil];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error){
                NSLog(@"Cannot complete request");
                return;
            }
            else{
                NSLog(@"successful request with: %@", result);
//                data =     (
//                            {
//                                id = 175963559418853;
//                                name = "Catt Whiskerr";
//                                picture =             {
//                                    data =                 {
//                                        "is_silhouette" = 0;
//                                        url = "https://scontent.xx.fbcdn.net/hprofile-xfp1/v/t1.0-1/p50x50/11745435_105196086495601_5948120944887724456_n.jpg?oh=5cfe4af084e0a192d15aefefc3464b23&oe=56B87428";
//                                    };
//                                };
//                            }
//                            );
                //NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                self.contentNSArray = [(NSDictionary *)result objectForKey:@"data"];// sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
                [self.chatsUITableView reloadData];
            }
        }];
    }

}

- (void) createTable{
    self.chatsUITableView = [[UITableView alloc] initWithFrame:self.view.frame
                                                         style:UITableViewStylePlain];
    self.chatsUITableView.delegate = self;
    self.chatsUITableView.dataSource = self;
    [self.chatsUITableView reloadData]; //"init", start querying data source/delegate
    //1. invokes cellForRowAtIndexPath to get cell obj (scrolling also calls this)
    //2. uses UITableViewCell obj to draw content of cell
    self.chatsUITableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview: self.chatsUITableView];
}

- (void)viewDidUnload {
    //self.tableView = nil;
    [super viewDidUnload];
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
    self.contentNSArray = [NSArray arrayWithObjects: d, d2, nil];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [self.contentNSArray count];
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    // The header for the section is the region name -- get this from the region at the section index.
//    return @"Bark at Me!";
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //reusing
    //NSIndexpath = describe section and row
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    //see if there is a cell we can reuse

    if (cell == nil) {
        //if no identifier, create one
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *item = (NSDictionary *)[self.contentNSArray objectAtIndex:indexPath.row];
    //              id:,
    //              name:,
    //              picture:
    //                  {
    //                      data:{
    //                          "is_silhouette": 0/1;
    //                          url:
    //                      }
    //                  };
    //          }
    cell.textLabel.text = [item objectForKey:@"name"];
    NSString * url = [[[item objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url ]]];
    cell.imageView.image = image;
//    dispatch_async(dispatch_get_main_queue(), ^(){
//        cell.imageView.image = image;
//        [self.chatsUITableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    });
    return cell;
}

//Alternating background color of cells
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
        cell.backgroundColor = altCellColor;
    }
}


@end
