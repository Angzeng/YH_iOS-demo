//
//  WriteTitleViewController.h
//  JH项目
//
//  Created by zhujinchi on 15/12/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *YHarticletitle;

@interface YHWriteTitleViewController : UIViewController <UITextFieldDelegate> //标题界面




@property (nonatomic,readonly) NSInteger screenWidth;//屏幕宽度
@property (nonatomic,readonly) NSInteger screenHeight;//屏幕高度 版本适配

@end
