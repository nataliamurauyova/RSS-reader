//
//  XMLParser.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/24/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "XMLParser.h"
#import "PartOfNews.h"
#import "NSString + NSStringAddition.h"

static NSString* const kXMLTagItem = @"item";
static NSString* const kXMLTagTitle = @"title";
static NSString* const kXMLTagDate = @"pubDate";
static NSString* const kXMLTagLink = @"link";
static NSString* const kXMLTagEnclosure = @"enclosure";
static NSString* const kXMLTagDescription = @"description";
static NSString* const kXMLTagDescriptionStart = @">";
static NSString* const kXMLTagDescriptionEnd = @"<br ";




@interface XMLParser () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *imageLink;
    NSMutableString *dates;
    NSMutableString *descriptionBeforeParsing;
    NSMutableString *description;
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

    return feeds;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    
    element=elementName;
    
    if([element isEqualToString:kXMLTagItem]){
        item = [[NSMutableDictionary alloc] init];
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        imageLink = [[NSMutableString alloc] init];
        dates = [[NSMutableString alloc] init];
        pubDate = [[NSDate alloc] init];
        descriptionBeforeParsing = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
    }
    if ([element isEqualToString:kXMLTagEnclosure]){
        NSString *urlString = [attributeDict objectForKey:@"url"];
        [imageLink appendString:urlString];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if([element isEqualToString:kXMLTagTitle]){
        [title appendString:string];
    } else if ([element isEqualToString:kXMLTagLink]){
        [link appendString:string];
    } else if ([element isEqualToString:kXMLTagDate]){
        [dates appendString:string];
    } else if ([element isEqualToString:kXMLTagDescription]){
        [descriptionBeforeParsing appendString:string];
        NSMutableArray *descrip = [descriptionBeforeParsing stringsBetweenString:kXMLTagDescriptionStart andString:kXMLTagDescriptionEnd];
        description = [[descrip componentsJoinedByString:@" "] mutableCopy];

    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"item"]){
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:dates forKey:@"dates"];
        [item setObject:imageLink forKey:@"imageLink"];
        [item setObject:description forKey:@"description"];
        PartOfNews *news = [[PartOfNews alloc] initWithTitle:title link:link pubDate:dates imageLink:imageLink subtitle:description];
        [feeds addObject:news];
       
        
    }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@",[parseError localizedDescription]);
}
@end
