//
//  PartOfNews.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/26/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "PartOfNews.h"

@implementation PartOfNews

-(instancetype)initWithTitle:(NSString *)title link:(NSString *)link pubDate:(NSString *)pubDate imageLink:(NSString *)imageLink{
    self = [super init];
    if(self){
        self.title = title;
        self.link = link;
        self.pubDate = pubDate;
        self.imageLink = imageLink;
}
    return self;
}

@end
