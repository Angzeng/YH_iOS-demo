//
//  WriteCommentViewController.h
//  JH项目
//
//  Created by zhujinchi on 15/12/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
//正文界面
@interface YHWriteCommentViewController : UIViewController<UITextViewDelegate>

@property (nonatomic,strong) NSString *aid;
@property (nonatomic,readonly) NSInteger screenWidth;  //屏幕宽度
@property (nonatomic,readwrite) BOOL isSubmitting; //是否提交按钮

@end
