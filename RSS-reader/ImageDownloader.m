//
//  ImageDownloader.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/27/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader

//- (void)downloadImageusingLink:(NSString *)imageLink{
//    self.imageLink = imageLink;
//    NSString *imageUrl = self.news.imageLink;
//    if(imageUrl){
//        cell.imageView.image = nil;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//            UIImage *image = [[UIImage alloc] initWithData:imageData];
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                cell.imageView.image = image;
//                [cell setNeedsLayout];
//            });
//        });
//    }
//}
@end
