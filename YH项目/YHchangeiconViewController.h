//
//  YHchangeiconViewController.h
//  YH项目
//
//  Created by norton on 16/7/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHchangeiconViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (nonatomic,readonly) NSInteger screenWidth;  //屏幕宽度
@property (nonatomic,readonly) NSInteger screenHeight;

@end
