//
//  YHResultView.m
//  YH项目
//
//  Created by zhujinchi on 16/6/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHMatchView.h"

@interface YHMatchView()

@property(nonatomic,strong)UIImageView *bgImgView;
@property(nonatomic,strong)UIImageView *leftView;
@property(nonatomic,strong)UIImageView *rightView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UILabel *explainLable;
@property(nonatomic,readwrite)UIEdgeInsets edge;

@end

@implementation YHMatchView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.edge = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return self;
}

-(void) setItems{
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    bgImg.image = [UIImage imageNamed:self.Items[0]];
    [self addSubview:bgImg];
    self.bgImgView = bgImg;
    
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0.12*self.frame.size.height, 0.09*self.frame.size.height, 0.82*self.frame.size.height, 0.82*self.frame.size.height)];
    [leftView setImage:[UIImage imageNamed:self.Items[1]]];
    [self addSubview:leftView];
     self.leftView = leftView;
    
    UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-0.94*self.frame.size.height, 0.09*self.frame.size.height, 0.82*self.frame.size.height, 0.82*self.frame.size.height)];
    [rightView setImage:[UIImage imageNamed:self.Items[2]]];
    [self addSubview:rightView];
    self.leftView = rightView;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height,0.5*self.frame.size.height-30, 100, 30)];
    [title setText:self.Items[3]];
    title.textColor = [UIColor whiteColor];
    [self addSubview:title];
    self.titleLable = title;
    //
    UILabel *explain = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height,0.5*self.frame.size.height, 200, 20)];
    [explain setText:self.Items[4]];
    explain.font=[UIFont systemFontOfSize:12];
    [self addSubview:explain];
    self.explainLable = explain;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
