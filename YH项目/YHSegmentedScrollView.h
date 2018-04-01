//
//  YHSegmentedScrollView.h
//  YH项目
//
//  Created by Apple on 16/4/20.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHSegmentedScrollView;

@protocol YHSegmTouchHandler <NSObject>

-(void) segmentedControlChangedValue:(YHSegmentedScrollView *)segmented;

@end

@interface YHSegmentedScrollView : UIScrollView

@property (nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,weak)id<YHSegmTouchHandler> segmTouchHandlerDelegate;

@end
