//
//  YHSearchScrollView.h
//  YH项目
//
//  Created by zhujinchi on 16/6/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHDataView.h"
#import "YHSearchBar.h"
#import "YHMatchView.h"
#import "YHInfoPopViewItems.h"

@class YHSearchScrollView;

@protocol YHSearchScrollViewTouchHandler <NSObject>

-(void) accessResultWithType:(NSInteger)type;

@end

@interface YHSearchScrollView : UIScrollView

@property(nonatomic,strong)YHDataView *dataView;
@property(nonatomic,strong)UIImageView *graphView;
@property(nonatomic,strong)YHSearchBar *searchBar;
@property(nonatomic,strong)YHMatchView *similarResultView;
@property(nonatomic,strong)YHMatchView *differentResultView;
@property(nonatomic,strong)YHMatchView *famousResultView;
@property(nonatomic,weak)id<YHSearchScrollViewTouchHandler> searchScrollViewTouchHandlerDelegate;

-(void) setItems:(YHInfoPopViewItems *)items;

@end
