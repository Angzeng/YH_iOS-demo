//
//  YHSearchScrollView.m
//  YH项目
//
//  Created by zhujinchi on 16/6/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHSearchScrollView.h"
#import "YHLoginViewController.h"
#import "YHintroductionViewController.h"

@interface YHSearchScrollView()

@property(nonatomic,readwrite)CGFloat totalHeight;
@property(nonatomic,strong)UIView *glassView;
@property(nonatomic,readwrite)CGSize screenSize;

@end

@implementation YHSearchScrollView

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.scrollEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
    }
    return  self;
}

-(void) setItems:(YHInfoPopViewItems *)items{
    _screenSize = [UIScreen mainScreen].bounds.size;
    
    _totalHeight = 0.0;
    
    YHDataView *dataView = [[YHDataView alloc] initWithFrame:CGRectMake(0, _totalHeight, self.frame.size.width, 180)];
    dataView.capacity = @[items.growsystem,
                          items.wealthsystem,
                          items.emotionsystem,
                          items.faithsystem,
                          items.toolsystem];
    YHCapacityOfUser = dataView.capacity;
    dataView.question_count = items.question_count;
    dataView.reg_all = items.reg_all;
    dataView.uname = items.uname;
    dataView.avatar = items.avatar;
    dataView.model = items.label;
    [self.dataView removeFromSuperview];
    [self addSubview:dataView];
    self.dataView = dataView;
    _totalHeight = _dataView.frame.size.height + _dataView.frame.origin.y;
    
    //
    [dataView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showintroduction)]];
    //
    
    CGFloat height = 100;
    //similar
    _similarResultView = [[YHMatchView alloc] initWithFrame:CGRectMake(0, _totalHeight+10, self.frame.size.width, height)];
    _similarResultView.Items = @[@"firstview_background",@"pick_icon_2",@"pick_icon_right",@"志同道合",@"匹配模型相近者"];
    _similarResultView.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_similarResultView setItems];
    _similarResultView.tag = 1;
    UITapGestureRecognizer *similarResult;
    similarResult = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accessResultView:)];
    [_similarResultView addGestureRecognizer:similarResult];
    [self addSubview:_similarResultView];
    _totalHeight = _similarResultView.frame.size.height + _similarResultView.frame.origin.y;
    
    //different
    _differentResultView = [[YHMatchView alloc] initWithFrame:CGRectMake(0, _totalHeight+10, self.frame.size.width, height)];
    _differentResultView.Items = @[@"firstview_background",@"pick_icon_1",@"pick_icon_right",@"优势互补",@"匹配模型互补者"];
    _differentResultView.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_differentResultView setItems];
    _differentResultView.tag = 2;
    UITapGestureRecognizer *differentResult;
    differentResult = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accessResultView:)];
    [_differentResultView addGestureRecognizer:differentResult];
    [self addSubview:_differentResultView];
    _totalHeight = _differentResultView.frame.size.height + _differentResultView.frame.origin.y;
    
    //famous
    _famousResultView = [[YHMatchView alloc] initWithFrame:CGRectMake(0, _totalHeight+10, self.frame.size.width, height)];
    _famousResultView.Items = @[@"firstview_background",@"pick_icon_3",@"pick_icon_right",@"财富先知",@"查看财富名人"];
    _famousResultView.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_famousResultView setItems];
    _famousResultView.tag = 3;
    UITapGestureRecognizer *famousResult;
    famousResult = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accessResultView:)];
    [_famousResultView addGestureRecognizer:famousResult];
    [self addSubview:_famousResultView];
    _totalHeight = _famousResultView.frame.size.height + _famousResultView.frame.origin.y;
    
    _totalHeight = _totalHeight>self.frame.size.height?_totalHeight:self.frame.size.height+1;
    self.contentSize = CGSizeMake(self.frame.size.width, _totalHeight);
    [self layoutIfNeeded];
}

-(void)showintroduction {
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    
    YHintroductionViewController *introduction = [[YHintroductionViewController alloc] init];
    [superController.navigationController pushViewController:introduction animated:YES];
}

-(void) accessResultView:(UIGestureRecognizer *) sender{
    [self.searchScrollViewTouchHandlerDelegate accessResultWithType:sender.view.tag];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
