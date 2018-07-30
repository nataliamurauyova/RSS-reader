//
//  HTML-parser.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/24/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTML_parser : NSObject
@property(strong,nonatomic)NSMutableArray* result;

-(NSArray*) doURLSession:(void(^)(NSMutableArray *destinationUrl))complition;
//-(void) downloadURL:(void(^)(NSArray *destinationUrl))complition;
@end
