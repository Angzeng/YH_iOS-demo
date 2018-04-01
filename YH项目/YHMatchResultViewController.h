//
//  YHMatchResultViewController.h
//  YH项目
//
//  Created by zhujinchi on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHMatchResultViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,readwrite)NSInteger type;
@property(nonatomic,readwrite)NSString *uid;

@end
