//
//  DetailNewsViewController.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 8/3/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailNewsViewController : UIViewController
@property(nonatomic) NSString* titleOfNews;
@property(nonatomic) NSString *subtitle;
@property(nonatomic) NSString *pubDate;
@property(nonatomic) NSString *link;
@property(nonatomic) NSString *mediaDestination;
@end
