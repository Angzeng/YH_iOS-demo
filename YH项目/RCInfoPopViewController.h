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

@interface RCInfoPopViewController : UIViewController

@property(nonatomic,strong) NSString *UID;
@property(nonatomic,weak)id<YHInfoPopViewHandler> InfoPopViewHandlerDelegate;
@property(nonatomic , strong) NSString *ifshowdelete;

@end
