//
//  WBDMessagesViewControllerV2.m
//  HackSC15Dogs
//
//  Created by Ryan Zhou on 11/15/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDMessagesViewControllerV2.h"

@implementation WBDMessagesViewControllerV2


-(void) viewDidLoad{

    [super viewDidLoad];
    [self createNSDictionaryTestData];
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
    cell.textLabel.text = [item objectForKey:@"mainTitleKey"];
    cell.detailTextLabel.text = [item objectForKey:@"secondaryTitleKey"];
    NSString *path = [[NSBundle mainBundle] pathForResource:[item objectForKey:@"imageKey"] ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
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
