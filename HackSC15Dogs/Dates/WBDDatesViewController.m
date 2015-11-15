//
//  WBDDatesViewController.m
//  HackSC15Dogs
//
//  Created by abc on 11/14/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import "WBDDatesViewController.h"

@interface WBDDatesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableArray *dates;
@end

@implementation WBDDatesViewController

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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Message Cell"];
    
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
        //[_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Message Cell"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
