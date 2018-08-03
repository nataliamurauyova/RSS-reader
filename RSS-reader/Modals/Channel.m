//
//  Channel.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 8/2/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "Channel.h"

@implementation Channel


- (instancetype)initWithName:(NSString *)channelName checkState:(BOOL)isChecked{
    self = [super init];
    if(self){
        self.channelName = channelName;
        self.isChecked = isChecked;
    }
    return self;
}
@end
