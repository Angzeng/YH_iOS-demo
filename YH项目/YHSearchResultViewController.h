//
//  YHSearchResultViewController.h
//  YH项目
//
//  Created by zhujinchi on 16/7/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHSearchResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,readwrite)NSString *string;

@end
