//
//  GRZXrowCell.m
//  个人中心
//
//  Created by lab on 15/10/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GRZXrowCell.h"

@implementation GRZXrowCell
+(instancetype)rowCellWithTableView:(UITableView *)tableView{

    NSString *ID = @"menu";
    GRZXrowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[GRZXrowCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(void)setMenu:(GRZXmenu *)menu{
    _menu = menu;
    
    NSString *imgName = menu.icon;
    NSString *text = menu.title;
    self.imageView.image = [UIImage imageNamed:imgName];
    
    self.textLabel.text = text;
    self.textLabel.textAlignment = NSTextAlignmentRight;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
