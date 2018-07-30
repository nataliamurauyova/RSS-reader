//
//  NSString + NSStringAddition.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/30/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "NSString + NSStringAddition.h"

@implementation NSString (NSStringAddition)

-(NSMutableArray*)stringsBetweenString:(NSString*)start andString:(NSString*)end
{
    
    NSMutableArray* strings = [NSMutableArray arrayWithCapacity:0];
    
    
    
    NSRange startRange = [self rangeOfString:start];
    
    for( ;; )
    {
        
        if (startRange.location != NSNotFound)
        {
            
            NSRange targetRange;
            
            targetRange.location = startRange.location + startRange.length;
            targetRange.length = [self length] - targetRange.location;
            
            NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
            
            if (endRange.location != NSNotFound)
            {
                
                targetRange.length = endRange.location - targetRange.location;
                [strings addObject:[self substringWithRange:targetRange]];
                
                NSRange restOfString;
                
                restOfString.location = endRange.location + endRange.length;
                restOfString.length = [self length] - restOfString.location;
                
                startRange = [self rangeOfString:start options:0 range:restOfString];
                
            }
            else
            {
                break;
            }
            
        }
        else
        {
            break;
        }
        
    }
    //NSLog(@"FROM METHOD %@",strings);
    NSString *str = [strings componentsJoinedByString:@" "];
    //NSLog(@"FROM METHOD %@",str);
    
    return strings;
    
}
@end
