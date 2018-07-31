//
//  XMLParser.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/24/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "XMLParser.h"
#import "PartOfNews.h"

@interface XMLParser () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *imageLink;
    NSMutableString *dates;
    NSDate *pubDate;
    NSString *element;
}
@end

@implementation XMLParser
- (NSMutableArray *)parseXML:(NSString*) urlForXML{
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:urlForXML];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
//    PartOfNews *news = [[PartOfNews alloc] init];
//    news = self.news;
    return feeds;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    
    element=elementName;
    
    if([element isEqualToString:@"item"]){
        item = [[NSMutableDictionary alloc] init];
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        imageLink = [[NSMutableString alloc] init];
        dates = [[NSMutableString alloc] init];
        pubDate = [[NSDate alloc] init];
    }
    if ([element isEqualToString:@"enclosure"]){
        NSString *urlString = [attributeDict objectForKey:@"url"];
        [imageLink appendString:urlString];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if([element isEqualToString:@"title"]){
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]){
        [link appendString:string];
        //NSLog(@"THE LINK IS %@",link);
        //    } else if ([element isEqualToString:@"description"]){
        //        [imageLink appendString:string];
        //NSLog(@"%@",imageLink);
    } else if ([element isEqualToString:@"pubDate"]){
        //        if ([element isEqualToString:@"img"]) {
        [dates appendString:string];
        //    }
    } else if ([element isEqualToString:@"enclosure"]){
        //        NSString *urlString = string;
        //        NSLog(@"%@",urlString);
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"item"]){
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:dates forKey:@"dates"];
        [item setObject:imageLink forKey:@"imageLink"];
        
        
        PartOfNews *news = [[PartOfNews alloc] initWithTitle:title link:link pubDate:dates imageLink:imageLink];
        //self.news = news;
        [feeds addObject:news];
        
    }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //[self.rssTableView reloadData];
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@",[parseError localizedDescription]);
}
@end
