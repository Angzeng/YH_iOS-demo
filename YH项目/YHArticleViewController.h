//
//  YHArticleViewController.h
//  YH项目
//
//  Created by zhujinchi on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHArticleScrollView.h"

@interface YHArticleViewController : UIViewController

@property(nonatomic,strong)YHArticleScrollView *articleScrollView;

-(id)initWithItems:(YHArticlesCellItems *)itemModel;

@end
