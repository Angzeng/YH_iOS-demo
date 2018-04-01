//
//  YHCommentViewController.h
//  YH项目
//
//  Created by zhujinchi on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *YHaid;


@interface YHCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSString *aid;
@property (nonatomic,strong) UITableView *commentTab;
@property (nonatomic,strong) UIButton *hoverbutton;


@end
