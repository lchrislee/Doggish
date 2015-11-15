//
//  WBDMessagesViewControllerV2.h
//  HackSC15Dogs
//
//  Created by Ryan Zhou on 11/15/15.
//  Copyright © 2015 Wannabedev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBDMessagesViewControllerV2 : UIViewController<UITableViewDelegate, UITableViewDataSource>{
}

@property (nonatomic, strong) NSArray *contentNSArray;
@property (nonatomic, retain) UITableView *chatsUITableView;

@end
