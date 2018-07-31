//
//  NSString + NSStringAddition.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/30/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringAddition)
-(NSMutableArray*)stringsBetweenString:(NSString*)start andString:(NSString*)end;
@end
