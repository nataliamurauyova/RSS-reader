//
//  FavoritesViewController.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/26/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartOfNews.h"

@interface FavoritesViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property(nonatomic) PartOfNews *favNews;

@end
