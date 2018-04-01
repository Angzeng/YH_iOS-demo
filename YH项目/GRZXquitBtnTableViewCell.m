//
//  GRZXquitBtnTableViewCell.m
//  个人中心
//
//  Created by Apple on 15/10/18.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GRZXquitBtnTableViewCell.h"
#import "GRZXMainController.h"


@implementation GRZXquitBtnTableViewCell 



- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)leaveButton:(UIButton *)sender {

 
    
}

-(void) performDismiss:(NSTimer *)timer
{
    [_exitalert dismissWithClickedButtonIndex:0 animated:NO];
    //    [_registeralert release];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
