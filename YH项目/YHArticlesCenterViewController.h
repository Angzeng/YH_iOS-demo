//
//  ArticlesCenterViewController.h
//  Test
//
//  Created by Zero on 15/11/7.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHArticlesCenterViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,readwrite) NSInteger articleType;
@property (nonatomic,strong) UITableView *articlesTab;
@property (nonatomic,strong) UIView *hoverview;
@property (nonatomic,strong) UIButton *hoverbutton;

@end
