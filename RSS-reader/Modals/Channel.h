//
//  Channel.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 8/2/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject
@property(nonatomic) NSString *channelName;
@property(assign,nonatomic) BOOL isChecked;


-(instancetype)initWithName:(NSString*)channelName checkState:(BOOL)isChecked;
@end
