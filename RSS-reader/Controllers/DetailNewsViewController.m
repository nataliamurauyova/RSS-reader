//
//  DetailNewsViewController.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 8/3/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "DetailNewsViewController.h"
#import "NewsDetailViewController.h"

@interface DetailNewsViewController ()
@property(nonatomic) UILabel *titlelabel;
@property(nonatomic) UILabel *subtitlelabel;
@property(nonatomic) UILabel *datelabel;
@property(nonatomic) UIImageView *imageView;
@property(nonatomic) UIButton *visitWebsite;
@property(nonatomic) UIView *containerView;


@end

@implementation DetailNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"mediaDestination - %@",self.mediaDestination);
  
    [self setUpViews];
}


-(void) setUpViews{
    [self createContainer];
    [self createTitleLabel];
    [self createSubitleLabel];
    [self createDateLabel];
    [self createImageView];
    [self createWebButton];
    [self setConstraints];
}
-(void) createTitleLabel{
    _titlelabel = [[UILabel alloc] init];
    _titlelabel.text = self.titleOfNews;
    _titlelabel.textAlignment = NSTextAlignmentNatural;
    _titlelabel.contentMode = UIViewContentModeScaleAspectFill;
    _titlelabel.font = [UIFont systemFontOfSize:30];
    _titlelabel.numberOfLines = 10;
    [self.containerView addSubview:_titlelabel];
}
-(void) createSubitleLabel{
    _subtitlelabel = [[UILabel alloc] init];
    _subtitlelabel.text = self.subtitle;
    _subtitlelabel.textAlignment = NSTextAlignmentNatural;
    _subtitlelabel.contentMode = UIViewContentModeScaleAspectFill;
    _subtitlelabel.font = [UIFont systemFontOfSize:18];
    _subtitlelabel.numberOfLines = 10;
    [self.containerView addSubview:_subtitlelabel];
    
}
-(void) createDateLabel{
    _datelabel = [[UILabel alloc] init];
    _datelabel.text = [self.pubDate substringWithRange:NSMakeRange(4, 18)];
    _datelabel.textAlignment = NSTextAlignmentNatural;
    _datelabel.textColor = [UIColor darkGrayColor];
    _datelabel.font = [UIFont systemFontOfSize:14];
    [self.containerView addSubview:_datelabel];
    
}
-(void) createImageView{
    _imageView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageWithContentsOfFile:self.mediaDestination];
    _imageView.image = image;
    [self.containerView addSubview:_imageView];
}
-(void)createWebButton{
    _visitWebsite = [[UIButton alloc] init];
    [_visitWebsite setTitle:@"Подробнее" forState:UIControlStateNormal];
    _visitWebsite.layer.cornerRadius = 20;
    [_visitWebsite addTarget:self action:@selector(goToWebSite:) forControlEvents:UIControlEventTouchUpInside];
   _visitWebsite.backgroundColor = [UIColor purpleColor];
    [self.containerView addSubview:_visitWebsite];
}
-(void)createContainer{
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_containerView];
}
-(void) goToWebSite: (UIButton*)sender{
    NewsDetailViewController *webView = [[NewsDetailViewController alloc] init];
    webView.linkToDownload = self.link;
    [self.navigationController pushViewController:webView animated:YES];
}
-(void) setConstraints{
    self.titlelabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subtitlelabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.datelabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.visitWebsite.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.containerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.titlelabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:10],
                                              [self.titlelabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
                                              [self.titlelabel.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:20]
                                              ]];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.subtitlelabel.topAnchor constraintEqualToAnchor:self.titlelabel.bottomAnchor constant:5],
                                              [self.subtitlelabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:10],
                                              [self.subtitlelabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor]
                                              ]];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.datelabel.topAnchor constraintEqualToAnchor:self.subtitlelabel.bottomAnchor constant:20],
                                              [self.datelabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:10],
                                              [self.datelabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
                                              ]];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.imageView.topAnchor constraintEqualToAnchor:self.datelabel.bottomAnchor constant:15],
                                              [self.imageView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:10],
                                              [self.imageView.heightAnchor constraintEqualToConstant:150],
                                              [self.imageView.widthAnchor constraintEqualToConstant:400]
                                              ]];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.visitWebsite.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:15],
                                              [self.visitWebsite.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:10],
                                              [self.visitWebsite.heightAnchor constraintEqualToConstant:50],
                                              [self.visitWebsite.widthAnchor constraintEqualToConstant:150]
                                              ]];
}
@end
