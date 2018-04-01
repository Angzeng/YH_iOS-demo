//
//  PopView.h
//  Test
//
//  Created by Zero on 15/12/1.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "YHInfoPopViewItems.h"

@interface groupInfoPopView : UIView

@property(nonatomic,strong) UIButton *friendBtn;
@property(nonatomic,strong) UIButton *concernBtn;
@property(nonatomic,readwrite) NSString *focusType;

-(id)initWithFrame:(CGRect)frame;
-(void)changeFocusInfo;
-(void) setItems:(YHInfoPopViewItems *)items;
@end
