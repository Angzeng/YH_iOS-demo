//
//  changegroupiconViewController.h
//  YH项目
//
//  Created by Angzeng on 29/08/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changegroupiconViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (nonatomic,readonly) NSInteger screenWidth;  //屏幕宽度
@property (nonatomic,readonly) NSInteger screenHeight;
@property (nonatomic , strong) NSString *avatarurl;
@property (nonatomic , strong) NSString *tid;

@end
