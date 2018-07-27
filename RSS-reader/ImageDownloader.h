//
//  ImageDownloader.h
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/27/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloader : NSObject
@property(nonatomic) NSString* imageLink;


-(void)downloadImageusingLink: (NSString*) imageLink;
@end
