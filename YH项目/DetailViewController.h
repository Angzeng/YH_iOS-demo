//
//  DetailViewController.h
//  YH项目
//
//  Created by Apple on 16/3/1.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

