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

   
        [super layoutSubviews];
    
        float desiredWidth = 70;
        float w = self.imageView.frame.size.width;
        if(w>desiredWidth){
            float subWidth = w - desiredWidth;
            self.imageView.frame = CGRectMake(self.imageView.frame.origin.x,self.imageView.frame.origin.y,desiredWidth,self.imageView.frame.size.height);
            self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x-subWidth,self.textLabel.frame.origin.y,self.textLabel.frame.size.width+subWidth,self.textLabel.frame.size.height);
            self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x-subWidth,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width+subWidth,self.detailTextLabel.frame.size.height);
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
//            UIButton *starButton = [UIButton buttonWithType:UIButtonTypeSystem];
//            //[starButton setTitle:@"Some title" forState:UIControlStateNormal];
//            [starButton setFrame:CGRectMake(0, 0, 30, 30)];
//            [starButton setTintColor:[UIColor grayColor]];
//            [starButton setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
//            [starButton addTarget:self action:@selector(handleMarkAsFavourite) forControlEvents:UIControlEventTouchUpInside];
//            self.accessoryView = starButton;
//                self.backgroundColor = [UIColor greenColor];
//                UIButton *starButton = [UIButton buttonWithType:UIButtonTypeSystem];
//                [starButton setTitle:@"Some title" forState:UIControlStateNormal];
//                [starButton setFrame:CGRectMake(0, 0, 10, 10)];
//                self.accessoryView = starButton;

//            self.imageView.layer.shadowPath =
        }
       [self.contentView layoutIfNeeded];
    

//    self.backgroundColor = [UIColor greenColor];
//    UIButton *starButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [starButton setTitle:@"Some title" forState:UIControlStateNormal];
//    [starButton setFrame:CGRectMake(0, 0, 50, 50)];
//    self.accessoryView = starButton;
    
}

@end
