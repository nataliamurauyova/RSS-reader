//
//  ListOfNewsTableViewCell.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/25/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "ListOfNewsTableViewCell.h"

@implementation ListOfNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
//    [super layoutSubviews];
//
//    float desiredWidth = 70;
//    float w = self.imageView.frame.size.width;
//    if(w>desiredWidth){
//        float subWidth = w - desiredWidth;
//        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x,self.imageView.frame.origin.y,desiredWidth,self.imageView.frame.size.height);
//        self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x-subWidth,self.textLabel.frame.origin.y,self.textLabel.frame.size.width+subWidth,self.textLabel.frame.size.height);
//        self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x-subWidth,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width+subWidth,self.detailTextLabel.frame.size.height);
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    }
    [UIView performWithoutAnimation:^{
        [super layoutSubviews];
        float desiredWidth = 70;
        float w = self.imageView.frame.size.width;
        if(w>desiredWidth){
            float subWidth = w - desiredWidth;
            self.imageView.frame = CGRectMake(self.imageView.frame.origin.x,self.imageView.frame.origin.y,desiredWidth,self.imageView.frame.size.height);
            self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x-subWidth,self.textLabel.frame.origin.y,self.textLabel.frame.size.width+subWidth,self.textLabel.frame.size.height);
            self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x-subWidth,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width+subWidth,self.detailTextLabel.frame.size.height);
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//            self.imageView.layer.shadowPath = 
        }
        [self.contentView layoutIfNeeded];

    }];
    
}
@end
