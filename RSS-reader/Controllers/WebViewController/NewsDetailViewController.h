//
//  NewsDetailViewController.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/24/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>

@interface NewsDetailViewController : UIViewController <UIWebViewDelegate>

@property(nonatomic) NSString *linkToDownload;
@property(nonatomic) UIActivityIndicatorView *activityIndicator;

@end
