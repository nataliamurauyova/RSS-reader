//
//  ListOfNews.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/23/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartOfNews.h"

@interface ListOfNews : UIViewController <UITableViewDelegate, UITableViewDataSource,NSXMLParserDelegate>
@property(nonatomic) UITableView *rssTableView;
@property(nonatomic)NSString* url;
@property(nonatomic) NSString *linkOfImage;
@property(nonatomic) PartOfNews* news;
@property(nonatomic) UIButton *star;
@end
