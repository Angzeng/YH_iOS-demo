//
//  GRZXcollecterCell.m
//  个人中心
//
//  Created by Apple on 15/11/8.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "GRZXcollecterCell.h"

@implementation GRZXcollecterCell

//创建cell
+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *reuseID = @"collect_cell";
    GRZXcollecterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GRZXcollecterCell" owner:nil options:nil] firstObject];    }
    return cell;
}
//设置数据
-(void)setCollect:(GRZXcollect *)collect{
    _collect = collect;
    
    self.title.text = collect.title;
    self.content.text = collect.content;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
