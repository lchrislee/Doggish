//
//  WBDMessagesViewController.m
//  HackSC15Dogs
//
//  Created by Ryan Zhou on 11/15/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDMessagesViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface WBDMessagesViewController ()
@property (nonatomic, strong) NSArray *contentNSArray;
@property (nonatomic, strong) UITableView *chatsUITableView;
@end

@implementation WBDMessagesViewController

-(void) viewDidLoad{

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getFaceBookData];
    [self createtable];
}

-(void) getFaceBookData{
    if( [FBSDKAccessToken currentAccessToken] == nil){
        NSLog(@"its nil");
    }
    else{
        NSLog(@"its not");
    }
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_friends"]){
        // create a request to actually get the friends
        FBSDKGraphRequest * request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/friends?fields=name,picture,link" parameters:nil];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error){
                NSLog(@"Cannot complete request");
                return;
            }
            NSLog(@"successful request with: %@", result);
            self.contentNSArray = [(NSDictionary *)result objectForKey:@"data"];
            [self.chatsUITableView reloadData];
        }];
    }

}

-(void) createtable{
    self.chatsUITableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
//    self.chatsUITableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [self.contentNSArray count];
}

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
    cell.textLabel.text = [item objectForKey:@"name"];
    NSString *url = [[[item objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    cell.imageView.image = image;
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
