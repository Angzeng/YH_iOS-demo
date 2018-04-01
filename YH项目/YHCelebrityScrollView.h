//
//  YHCelebrityScrollView.h
//  YH项目
//
//  Created by zhujinchi on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHCelebrityItem.h"

@interface YHCelebrityScrollView : UIScrollView


@property(nonatomic,strong) YHCelebrityItem *item;

-(void)setContent;

@end
