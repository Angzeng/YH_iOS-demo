//
//  GRZXrowCell.h
//  个人中心
//
//  Created by lab on 15/10/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRZXmenu.h"

@interface GRZXrowCell : UITableViewCell

@property (nonatomic, strong) GRZXmenu *menu;

+(instancetype)rowCellWithTableView:(UITableView *)tableView;

@end
