//
//  PopView.m
//  Test
//
//  Created by Zero on 15/12/1.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "groupInfoPopView.h"
#import "YHInfoDataView.h"
#import "YHLoginViewController.h"
#import <MJExtension/MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#define PI 3.14159265358979323846

@interface groupInfoPopView ()

@property(nonatomic,strong) UIImageView *bgImgView;
@property(nonatomic,strong) UIImageView *iconImgView;
@property(nonatomic,strong) NSArray *ability;
@property(nonatomic,strong) YHInfoDataView *dataView;
@property(nonatomic,strong) UILabel *modelLabel;
@property(nonatomic,strong) UILabel *accuLabel;
@property(nonatomic,strong) UILabel *atteLabel;
@property(nonatomic,strong) UIImageView *IDImgView;
@property(nonatomic,strong) UILabel *IDLabel;
@property(nonatomic,strong) UIImageView *nameImgView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIImageView *locatImgView;
@property(nonatomic,strong) UILabel *locatLabel;
@property(nonatomic,strong) UIImageView *signImgView;
@property(nonatomic,strong) UILabel *signLabel;

@property(nonatomic,readwrite) UIEdgeInsets edgeInset;
@property(nonatomic,strong) UIAlertView *textalert;

@end

@implementation groupInfoPopView

-(id)initWithFrame:(CGRect)frame{
    CGFloat widthScale = 0.82;
    CGFloat heightScale = 0.78;
    self = [super initWithFrame:CGRectMake(frame.size.width*(1-widthScale)/2, 0, frame.size.width*widthScale, frame.size.height*heightScale)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _focusType = @"3";
        
        UIImageView *bg = [[UIImageView alloc] init];
        [self addSubview:bg];
        self.bgImgView = bg;
        self.bgImgView.image = [UIImage imageNamed:@"popview_background_top2"];
        
        UIImageView *icon = [[UIImageView alloc] init];
        [self addSubview:icon];
        self.iconImgView = icon;
        
        self.ability = @[@"成长",@"财值",@"情智",@"信念",@"工具"];
        
        UILabel *model = [[UILabel alloc] init];
        [self addSubview:model];
        self.modelLabel = model;
        self.modelLabel.textAlignment = NSTextAlignmentCenter;
        self.modelLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
        self.accuLabel.backgroundColor = [UIColor clearColor];
        
        UILabel *accuData = [[UILabel alloc] init];
        [self addSubview:accuData];
        self.accuLabel = accuData;
        self.accuLabel.textAlignment = NSTextAlignmentCenter;
        self.accuLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
        self.accuLabel.backgroundColor = [UIColor clearColor];
        
        UILabel *atteData = [[UILabel alloc] init];
        [self addSubview:atteData];
        self.atteLabel = atteData;
        self.atteLabel.textAlignment = NSTextAlignmentCenter;
        self.atteLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
        self.atteLabel.backgroundColor = [UIColor clearColor];
        
        UIImageView *ID = [[UIImageView alloc] init];
        [self addSubview:ID];
        self.IDImgView = ID;
        self.IDImgView.image = [UIImage imageNamed:@"imfomation_icon_uid"];
        
        UILabel *IDLabel = [[UILabel alloc] init];
        [self addSubview:IDLabel];
        self.IDLabel = IDLabel;
        self.IDLabel.textAlignment = NSTextAlignmentLeft;
        self.IDLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0f];
        
        UIImageView *name = [[UIImageView alloc] init];
        [self addSubview:name];
        self.nameImgView = name;
        self.nameImgView.image = [UIImage imageNamed:@"imfomation_icon_profile"];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0f];
        
        UIImageView *locat = [[UIImageView alloc] init];
        [self addSubview:locat];
        self.locatImgView = locat;
        self.locatImgView.image = [UIImage imageNamed:@"imfomation_icon_local"];
        
        UILabel *locatLabel = [[UILabel alloc] init];
        [self addSubview:locatLabel];
        self.locatLabel = locatLabel;
        self.locatLabel.textAlignment = NSTextAlignmentLeft;
        self.locatLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0f];
        
        UIImageView *sign = [[UIImageView alloc] init];
        [self addSubview:sign];
        self.signImgView = sign;
        self.signImgView.image = [UIImage imageNamed:@"imfomation_icon_intoduction"];
        
        UILabel *signLabel = [[UILabel alloc] init];
        [self addSubview:signLabel];
        self.signLabel = signLabel;
        self.signLabel.textAlignment = NSTextAlignmentLeft;
        self.signLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0f];
        
        UIButton *f_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [f_btn setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, -(self.frame.size.height*0.12>44?44:self.frame.size.height*0.12))];
        [f_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        f_btn.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:18.0f];
        _friendBtn = f_btn;
        [self addSubview:_friendBtn];
        
        UIButton *c_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [c_btn setFrame:CGRectMake(self.frame.size.width, self.frame.size.height, -self.frame.size.width/2, -(self.frame.size.height*0.12>44?44:self.frame.size.height*0.12))];
        [c_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        c_btn.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:18.0f];
        _concernBtn = c_btn;
        //[self addSubview:_concernBtn];
        
        self.edgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return self;
}

-(void) drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.bgImgView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.16)];
    
    [self.iconImgView setFrame:CGRectMake(self.frame.size.width/2-self.bgImgView.frame.size.height/2+self.edgeInset.top, self.edgeInset.top, self.bgImgView.frame.size.height - 2*self.edgeInset.top, self.bgImgView.frame.size.height - 2*self.edgeInset.top)];
    self.iconImgView.layer.cornerRadius = self.iconImgView.frame.size.width/2;
    self.iconImgView.clipsToBounds = YES;
    self.iconImgView.layer.borderWidth = 0.0f;
    self.iconImgView.layer.borderColor = [UIColor clearColor].CGColor;
    
    //绘制直线
    CGPoint point[2];
    point[0] = CGPointMake(rect.size.width/2, self.bgImgView.frame.origin.y+self.bgImgView.frame.size.height+self.edgeInset.top);
    point[1] = CGPointMake(point[0].x, rect.size.height/2-self.edgeInset.bottom);
    CGContextSetLineWidth(context, 0.5);
    [[UIColor grayColor] setStroke];
    CGContextAddLines(context, point, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGSize size = CGSizeMake(self.frame.size.width/2-4*self.edgeInset.left, ((point[1].y-point[0].y)/2 - 4*self.edgeInset.top)/2);
    [self.modelLabel setFrame:CGRectMake(self.frame.size.width/2+2*self.edgeInset.left, point[0].y+self.edgeInset.left, size.width, (point[1].y-point[0].y)/2 - 2*self.edgeInset.bottom)];
    
    CGRect rectangle1 = CGRectMake(self.frame.size.width/2+2*self.edgeInset.left, (point[0].y+point[1].y)/2+self.edgeInset.top, size.width, size.height);
    CGRect rectangle2 = CGRectMake(rectangle1.origin.x, rectangle1.origin.y+rectangle1.size.height+self.edgeInset.top*2,rectangle1.size.width, rectangle1.size.height);
    //标签
    [self.accuLabel setFrame:rectangle1];
    [self.atteLabel setFrame:rectangle2];
    
    CGFloat disp = self.edgeInset.top+self.edgeInset.bottom;
    CGFloat h = (rect.size.height/2 - _friendBtn.frame.size.height - self.edgeInset.top - self.edgeInset.bottom -disp*5)/4;
    
    size = CGSizeMake(h, h);
    CGFloat Px =  h+disp*2;
    CGFloat Py = self.frame.size.height/2 + self.edgeInset.top;
    
    point[0] = CGPointMake(Px, Py);
    point[1] = CGPointMake(Px, rect.size.height - _friendBtn.frame.size.height - self.edgeInset.bottom);
    CGContextSetLineWidth(context, 0.5);
    [[UIColor grayColor] setStroke];
    CGContextAddLines(context, point, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    //图标
    Py += disp;
    [self.IDImgView setFrame:CGRectMake(disp,Py,size.width,size.height)];
    self.IDImgView.layer.cornerRadius = self.IDImgView.frame.size.width/2;
    self.IDImgView.clipsToBounds = YES;
    self.IDImgView.layer.borderWidth = 0.0f;
    self.IDImgView.layer.borderColor = [UIColor clearColor].CGColor;
    
    [self.nameImgView setFrame:CGRectMake(disp,Py+size.height+disp,size.width,size.height)];
    self.nameImgView.layer.cornerRadius = self.nameImgView.frame.size.width/2;
    self.nameImgView.clipsToBounds = YES;
    self.nameImgView.layer.borderWidth = 0.0f;
    self.nameImgView.layer.borderColor = [UIColor clearColor].CGColor;
    
    [self.locatImgView setFrame:CGRectMake(disp,Py+2*(size.height+disp),size.width,size.height)];
    self.locatImgView.layer.cornerRadius = self.locatImgView.frame.size.width/2;
    self.locatImgView.clipsToBounds = YES;
    self.locatImgView.layer.borderWidth = 0.0f;
    self.locatImgView.layer.borderColor = [UIColor clearColor].CGColor;
    
    [self.signImgView setFrame:CGRectMake(disp,Py+3*(size.height+disp),size.width,size.height)];
    self.signImgView.layer.cornerRadius = self.signImgView.frame.size.width/2;
    self.signImgView.clipsToBounds = YES;
    self.signImgView.layer.borderWidth = 0.0f;
    self.signImgView.layer.borderColor = [UIColor clearColor].CGColor;
    
    //标签
    [self.IDLabel setFrame:CGRectMake(Px+disp, self.IDImgView.frame.origin.y,self.frame.size.width-Px-5*self.edgeInset.right, size.height)];
    [self.nameLabel setFrame:CGRectMake(Px+disp, self.nameImgView.frame.origin.y, self.frame.size.width-Px-5*self.edgeInset.right, size.height)];
    [self.locatLabel setFrame:CGRectMake(Px+disp, self.locatImgView.frame.origin.y, self.frame.size.width-Px-5*self.edgeInset.right, size.height)];
    [self.signLabel setFrame:CGRectMake(Px+disp, self.signImgView.frame.origin.y, self.frame.size.width-Px-5*self.edgeInset.right, size.height)];
    
    //绘制直线
    point[0] = CGPointMake(self.edgeInset.left, _friendBtn.frame.origin.y);
    point[1] = CGPointMake(self.frame.size.width-self.edgeInset.right, point[0].y);
    CGContextSetLineWidth(context, 0.8);
    [[UIColor grayColor] setStroke];
    CGContextAddLines(context, point, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
//    point[0] = CGPointMake(self.frame.size.width/2, _friendBtn.frame.origin.y+self.edgeInset.top);
//    point[1] = CGPointMake(point[0].x, _friendBtn.frame.origin.y+_friendBtn.frame.size.height-self.edgeInset.bottom);
//    [[UIColor grayColor] setStroke];
//    CGContextSetLineWidth(context, 0.8);
//    CGContextAddLines(context, point, 2);
//    CGContextDrawPath(context, kCGPathStroke);
}

-(void) setItems:(YHInfoPopViewItems *)items{
    NSArray *capacity = @[items.growsystem,
                          items.wealthsystem,
                          items.emotionsystem,
                          items.faithsystem,
                          items.toolsystem];
    self.dataView = [[YHInfoDataView alloc]initWithFrame:CGRectMake(0, _bgImgView.frame.origin.y+_bgImgView.frame.size.height, self.frame.size.width/2, self.frame.size.height*0.34) WithData:capacity];
    [self addSubview:_dataView];
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",items.avatar]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
    UIColor *color = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    NSString *login = [NSString stringWithFormat:@"已登录%@天",items.reg_all];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:login];
    [str1 addAttribute:NSForegroundColorAttributeName value:color range:[login rangeOfString:[NSString stringWithFormat:@"%@",items.reg_all]]];
    self.accuLabel.attributedText = str1;
    NSString *question = [NSString stringWithFormat:@"已回答%@题",items.question_count];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:question];
    [str2 addAttribute:NSForegroundColorAttributeName value:color range:[question rangeOfString:[NSString stringWithFormat:@"%@",items.question_count]]];
    self.accuLabel.attributedText = str1;
    self.atteLabel.attributedText = str2;
    self.IDLabel.text = items.uid;
    self.nameLabel.text = items.uname;
    self.locatLabel.text = items.region;
    self.signLabel.text = items.introduce;
    [_friendBtn setTitle:@"加好友" forState:UIControlStateNormal];
    switch (items.label.integerValue) {
        case 0:
            [self.modelLabel setText:@"财富角色 : 军师"];
            break;
        case 1:
            [self.modelLabel setText:@"财富角色 : 海盗"];
            break;
        case 2:
            [self.modelLabel setText:@"财富角色 : 发动机"];
            break;
        case 3:
            [self.modelLabel setText:@"财富角色 : 安全阀"];
            break;
        default:
            [self.modelLabel setText:@"财富角色 : 未定义"];
            break;
    }
    if ([items.focus isEqualToString:@"1"]) {
        _focusType = @"2";
    }else if ([items.focus isEqualToString:@"0"]){
        _focusType = @"1";
    }else{
        _focusType = @"3";
    }
    [self changeFocusInfo];
}

-(void)changeFocusInfo{
    if ([_focusType isEqualToString:@"2"]) {
        [_concernBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [_concernBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
}

@end
