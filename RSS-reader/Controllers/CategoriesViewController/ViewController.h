//
//  ViewController.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/23/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate,UIAdaptivePresentationControllerDelegate>

@property(nonatomic) UITableView *tableView;
@property(assign,nonatomic) BOOL *isMarked;
@property(nonatomic) NSMutableArray* allChannels;

@end

