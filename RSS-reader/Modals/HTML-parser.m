//
//  HTML-parser.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/24/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "HTML-parser.h"
#import "ViewController.h"
#import "NSString + NSStringAddition.h"

static NSString *const kListBegin = @"<li class=\"lists__li lists__li_head\">";
static NSString *const kListEnd = @"<i class=\"main-shd\"><i class=\"main-shd-i\">";
static NSString* const kURLStart = @"a href=\"";
static NSString* const kURLEnd = @"\">";

@interface HTML_parser()
@property(assign,nonatomic) BOOL flag;
@property(strong,nonatomic) NSURL* destinationURL;


@end

@implementation HTML_parser


-(NSArray*) getUrlsForParsing:(void(^)(NSMutableArray *parseURLs))complition{
    NSURL *url = [NSURL URLWithString:@"https://news.tut.by/rss.html"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDownloadTask *dataTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *documentsDirectory = [urls objectAtIndex:0];
        NSURL *originalUrl = [NSURL URLWithString:[location lastPathComponent]];
        NSURL *destinationUrl = [documentsDirectory URLByAppendingPathComponent:[originalUrl lastPathComponent]];
        
        
        NSError *err;
        NSLog(@"%@", location);
        [fileManager copyItemAtURL:location toURL:destinationUrl error:&err];
        self.destinationURL = destinationUrl;
        //NSLog(@"%@", self.destinationURL);
        NSData *data = [[NSData alloc] initWithContentsOfURL:destinationUrl];
        NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSMutableArray *str = [resStr stringsBetweenString:kListBegin andString:kListEnd];
        //NSLog(@"%@",str);
        NSString *strFromArr = [str componentsJoinedByString:@" "];
        self.result = [strFromArr stringsBetweenString:kURLStart andString:kURLEnd];
        //NSLog(@"%@",self.result);
        
        complition(self.result);
        
        //NSLog(@"%@",self.result);
    }];
    [dataTask resume];
    
    return self.result;
    
}



@end
