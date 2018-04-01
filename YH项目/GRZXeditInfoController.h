//
//  GRZXeditInfoController.h
//  个人中心
//
//  Created by Apple on 15/11/8.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRZXuser.h"
@class GRZXeditInfoController;

@protocol GRZXeditInfoControllerdelegate <NSObject>

-(void)saveInfoWithControl:(GRZXeditInfoController *)controller andUser:(GRZXuser *)user;

@end

@interface GRZXeditInfoController : UIViewController

@property (nonatomic,readonly) NSInteger screenWidth;//屏幕宽度
@property (nonatomic,readonly) NSInteger screenHeight;//屏幕高度 版本适配



@property (nonatomic,strong) id<GRZXeditInfoControllerdelegate> delegate;

@property (nonatomic,strong) GRZXuser *user;

@end
