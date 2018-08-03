//
//  XMLParser.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/24/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartOfNews.h"

@interface XMLParser : NSObject <NSXMLParserDelegate>

-(NSMutableArray*)parseXML:(NSString*) urlForXML;

@end
