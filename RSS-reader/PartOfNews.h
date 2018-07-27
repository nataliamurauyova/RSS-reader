//
//  PartOfNews.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/26/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartOfNews : NSObject
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *link;
@property(strong,nonatomic) NSString *pubDate;
@property(strong,nonatomic) NSString *imageLink;

-(instancetype)initWithTitle:(NSString*)title link:(NSString*)link pubDate:(NSString*)pubdate imageLink:(NSString*)imageLink;
@end
