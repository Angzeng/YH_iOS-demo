//
//  YHCelebrityScrollView.m
//  YH项目
//
//  Created by zhujinchi on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHCelebrityScrollView.h"
#import "YHCompareView.h"


@interface YHCelebrityScrollView()

@property(nonatomic,strong) YHCompareView *compareView;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *comparetLab;
@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UILabel *rightLab;
@property(nonatomic,readwrite)CGSize screenSize;
@property (nonatomic,readwrite) UIEdgeInsets edgeInset;


@end

@implementation YHCelebrityScrollView

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.edgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _screenSize = [UIScreen mainScreen].bounds.size;
        self.backgroundColor = [UIColor whiteColor];
        self.scrollEnabled = YES;
        self.alwaysBounceVertical = YES;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        
        _contentLab = [[UILabel alloc]init];
        [self addSubview:_contentLab];
        
        _comparetLab = [[UILabel alloc]init];
        [self addSubview:_comparetLab];
        
        _leftLab = [[UILabel alloc]init];
        [self addSubview:_leftLab];
        
        _rightLab = [[UILabel alloc]init];
        [self addSubview:_rightLab];
        
        _compareView = [[YHCompareView alloc]init];
        [self addSubview:_compareView];
        
        [_contentLab setLineBreakMode:NSLineBreakByWordWrapping];
        _contentLab.numberOfLines = 0;
        [_contentLab setTextAlignment:NSTextAlignmentLeft];
        [_contentLab setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:14.0f]];
        
        _comparetLab.text = @"数据对比";
        [_comparetLab setTextAlignment:NSTextAlignmentCenter];
        [_comparetLab setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:18.0f]];
        
        _leftLab.text = @"富豪数据";
        [_leftLab setTextAlignment:NSTextAlignmentCenter];
        [_leftLab setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:18.0f]];
        
        _rightLab.text = @"我的数据";
        [_rightLab setTextAlignment:NSTextAlignmentCenter];
        [_rightLab setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:18.0f]];
    }
    return  self;
}

-(void)layoutSubviews{
    [_comparetLab setFrame:CGRectMake(0, _edgeInset.top, self.frame.size.width, 20)];
    [_leftLab setFrame:CGRectMake(0, _comparetLab.frame.size.height+_comparetLab.frame.origin.y+2*_edgeInset.top, _screenSize.width/2, 20)];
    [_rightLab setFrame:CGRectMake(self.frame.size.width, _leftLab.frame.origin.y, -_leftLab.frame.size.width, _leftLab.frame.size.height)];
    
    [_compareView setFrame:CGRectMake(0, _rightLab.frame.size.height+_rightLab.frame.origin.y, _screenSize.width, 150)];
    _compareView.capacityOfCelebrity = @[_item.growsystem,
                                         _item.wealthsystem,
                                         _item.emotionsystem,
                                         _item.faithsystem,
                                         _item.toolsystem];
    
    CGSize Size = [_contentLab sizeThatFits:CGSizeMake(self.frame.size.width-2*self.edgeInset.left-2*self.edgeInset.right, MAXFLOAT)];
    [_contentLab setFrame:CGRectMake((self.frame.size.width-Size.width)/2, _compareView.frame.origin.y+_compareView.frame.size.height+2*_edgeInset.top, Size.width, Size.height)];
    self.contentSize = CGSizeMake(self.frame.size.width,_contentLab.frame.origin.y+_contentLab.frame.size.height+_edgeInset.bottom);
}

-(void)setContent{
    NSString *string = _item.introduce;
    NSString *lastChar = [string substringFromIndex:string.length-1];
    while([lastChar isEqualToString:@"\r"] || [lastChar isEqualToString:@"\n"]) {
        string = [string substringToIndex:string.length-2];
        lastChar = [string substringFromIndex:string.length-1];
    }
    _contentLab.text = string;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
