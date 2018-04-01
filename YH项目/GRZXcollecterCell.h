//
//  GRZXcollecterCell.h
//  个人中心
//
//  Created by Apple on 15/11/8.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRZXcollect.h"

@interface GRZXcollecterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (nonatomic,strong) GRZXcollect *collect;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
