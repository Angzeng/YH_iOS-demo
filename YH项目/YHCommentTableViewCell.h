//
//  YHCommentTableViewCell.h
//  YH项目
//
//  Created by zhujinchi on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHCommentCellItems.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface YHCommentTableViewCell : UITableViewCell

@property(nonatomic,strong) YHCommentCellItems *itemModel;
@property(nonatomic,strong) UIImageView* iconImgView;
@property(nonatomic,readwrite) CGFloat totalHeight;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void) setItemModel:(YHCommentCellItems *)itemModel;

@end
