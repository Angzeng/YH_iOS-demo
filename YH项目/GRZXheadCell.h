//
//  GRZXheadCell.h
//  个人中心
//
//  Created by Apple on 15/11/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRZXuser.h"
@class GRZXheadCell;

// 通过代理委托主控制器完成页面跳转
@protocol headCellDelegate <NSObject>

-(void)goEditViewWithCell:(GRZXheadCell *)cell;

@end

@interface GRZXheadCell : UITableViewCell



@property (nonatomic,strong) id<headCellDelegate> delegate;
@property (nonatomic,strong) GRZXuser *user;

@end
