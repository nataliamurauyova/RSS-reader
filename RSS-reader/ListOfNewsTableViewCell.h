//
//  ListOfNewsTableViewCell.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/25/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListOfNews.h"

@interface ListOfNewsTableViewCell : UITableViewCell
@property(nonatomic) ListOfNews* link;
@property(nonatomic) UIButton* star;


//-(NSIndexPath*) getIndexPath;
@end
