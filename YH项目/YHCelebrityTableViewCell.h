//
//  YHCelebrityTableViewCell.h
//  YH项目
//
//  Created by zhujinchi on 16/7/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHMatchResultCellItems.h"

@interface YHCelebrityTableViewCell : UITableViewCell

@property(nonatomic,readwrite) CGRect tableFrame;
@property(nonatomic,strong) YHMatchResultCellItems *itemModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void) setItemModel;

@end
