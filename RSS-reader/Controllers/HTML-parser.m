//
//  HTML-parser.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/24/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "HTML-parser.h"

static NSString *const begin = @"<ul class=\"b-lists\"><li class=\"lists__li\">";
static NSString *const end = @"<i class=\"main-shd\"><i class=\"main-shd-i\">";

@interface HTML_parser()
@property(assign,nonatomic) BOOL flag;
@property(strong,nonatomic) NSURL* destinationURL;


@end

@implementation HTML_parser
-(NSArray*) doURLSession{
    NSURL *url = [NSURL URLWithString:@"https://news.tut.by/rss.html"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    //    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        NSLog(@"%@",result);
    //    }];
    NSURLSessionDataTask *dataTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *documentsDirectory = [urls objectAtIndex:0];
        NSURL *originalUrl = [NSURL URLWithString:[location lastPathComponent]];
        NSURL *destinationUrl = [documentsDirectory URLByAppendingPathComponent:[originalUrl lastPathComponent]];
        
        
        NSError *err;
        NSLog(@"%@", location);
        [fileManager copyItemAtURL:location toURL:destinationUrl error:&err];
        self.destinationURL = destinationUrl;
        NSLog(@"%@", self.destinationURL);
        NSData *data = [[NSData alloc] initWithContentsOfURL:destinationUrl];
        NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *temp = [self parseHTML:resStr];
        
        self.result = [[self parseHTML2:temp] mutableCopy];
        //[self printError:err withDescr:@"Failed to copy item"];
        NSLog(@"%@",self.result);
    }];
    [dataTask resume];
    return self.result;
}
- (NSArray *)parseHTML:(NSString* )feedStr {
    NSArray<NSString*> *temp = [feedStr componentsSeparatedByString:@"\n"];
    NSLog(@"%lu", temp.count);
    NSMutableArray<NSString *> *result = [NSMutableArray array];
    
    for(int i = 0; i < temp.count; i++) {
        if([[temp objectAtIndex:i] isEqualToString:begin]) {
            self.flag = YES;
        }
        if(self.flag == YES) {
            [result addObject:temp[i]];
        }
        if([temp[i+1] containsString:end]) {
            self.flag = NO;
            break;
        }
    }
    NSLog(@"%lu", result.count);
    return [result copy];
}

- (NSArray *)parseHTML2:(NSArray* )feedArr {
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\<a href=\"(.*?)\\\">" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray *tempArr; NSMutableArray *matches = [NSMutableArray array];
    for(NSString *item in feedArr) {
        tempArr = [regularExpression matchesInString:item options:0 range:NSMakeRange(0, [item length])];
        for(NSTextCheckingResult *match in tempArr) {
            NSRange range = [match rangeAtIndex:1];
            [matches addObject:[item substringWithRange:range]];
        }
    }
    return [matches copy];
}
@end
