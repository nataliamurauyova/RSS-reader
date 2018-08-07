//
//  PopoverViewController.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 8/2/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Channel.h"

@interface PopoverViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic) Channel *channel;
@property(nonatomic) NSMutableArray* dataSource;
@property(assign) BOOL isChecked;
@property(nonatomic) NSMutableArray *checkmarkStates;

@end
