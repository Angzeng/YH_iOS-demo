//
//  ArticlesTableViewCell.h
//  Test
//
//  Created by Zero on 15/11/8.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "YHArticlesCellItems.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface YHArticlesTableViewCell : UITableViewCell

@property(nonatomic,strong) YHArticlesCellItems *itemModel;
@property(nonatomic,strong) UIImageView* iconImgView;
@property(nonatomic,strong) UIImageView* btnImgView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void) setItemModel:(YHArticlesCellItems *)itemModel;

@end
