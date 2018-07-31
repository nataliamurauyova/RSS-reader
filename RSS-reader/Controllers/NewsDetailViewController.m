//
//  NewsDetailViewController.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/24/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController () {
    UIView *loadingView;
}

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    [self.view addSubview:webView];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [webView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [webView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [webView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [webView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
    [self.view addSubview:webView];
    webView.delegate = self;
    
    NSString *encodedString = [self.linkToDownload stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    

    loadingView = [[UIView alloc] init];
    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
    loadingView.layer.cornerRadius = 5;
    [self.view addSubview:loadingView];
    loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [loadingView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
                                              [loadingView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
                                              [loadingView.widthAnchor constraintEqualToConstant:90],
                                              [loadingView.heightAnchor constraintEqualToConstant:90]
                                              ]];
    
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView addSubview:activityView];
    activityView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [activityView.centerXAnchor constraintEqualToAnchor:loadingView.centerXAnchor],
                                              [activityView.centerYAnchor constraintEqualToAnchor:loadingView.centerYAnchor],
                                              [activityView.widthAnchor constraintEqualToConstant:40],
                                              [activityView.heightAnchor constraintEqualToConstant:40]
                                              ]];
    [activityView startAnimating];
 
  

    UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
    lblLoading.text = @"Loading...";
    lblLoading.textColor = [UIColor whiteColor];
    lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
    lblLoading.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:lblLoading];
    lblLoading.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [lblLoading.bottomAnchor constraintEqualToAnchor:loadingView.bottomAnchor],
                                              [lblLoading.leadingAnchor constraintEqualToAnchor:loadingView.leadingAnchor],
                                              [lblLoading.trailingAnchor constraintEqualToAnchor:loadingView.trailingAnchor],
                                              [lblLoading.heightAnchor constraintEqualToConstant:30]
                                              ]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [loadingView setHidden:NO];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [loadingView setHidden:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [loadingView setHidden:YES];
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 450, 200, 60)];
    [errorLabel setText:@"Sorry, there're some problems with network."];
    [errorLabel setNumberOfLines:3];
    [self.view addSubview:errorLabel];
    errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [errorLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
                                              [errorLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
                                              [errorLabel.widthAnchor constraintEqualToConstant:150],
                                              [errorLabel.heightAnchor constraintEqualToConstant:150]
                                              ]];
    NSLog(@"Error - %@",[error localizedDescription]);
}


@end
