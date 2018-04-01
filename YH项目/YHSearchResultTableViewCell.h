//
//  YHSearchResultTableViewCell.h
//  YH项目
//
//  Created by zhujinchi on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHMatchResultCellItems.h"

@interface YHSearchResultTableViewCell : UITableViewCell

@property(nonatomic,strong) YHMatchResultCellItems *itemModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void) setItemModel;

@end
