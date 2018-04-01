//
//  YHInfoPopViewController.h
//  YH项目
//
//  Created by 渡。 on 2017/8/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YHInfoPopViewHandler <NSObject>

-(id)getNavigationController;

@end

@interface groupInfoPopViewController : UIViewController

@property(nonatomic,strong) NSString *UID;
@property(nonatomic,weak)id<YHInfoPopViewHandler> InfoPopViewHandlerDelegate;
@property(nonatomic , strong) NSString *ifshowdelete;
@property(nonatomic , strong) NSString *groupmemberid;
@property(nonatomic , strong) NSString *groupname;
@property(nonatomic , strong) NSString *groupid;

@end
