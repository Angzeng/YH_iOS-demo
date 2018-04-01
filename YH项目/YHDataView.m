//
//  YHDataView.m
//  YH项目
//
//  Created by Apple on 16/4/19.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "YHDataView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define PI 3.14159265358979323846

@interface YHDataView()

@property(nonatomic,strong)UIImageView *iconImgView;
@property(nonatomic,strong) UILabel *unameLabel;
@property(nonatomic,strong) UILabel *modelLabel;
@property(nonatomic,strong) UILabel *accuLabel;
@property(nonatomic,strong) UILabel *atteLabel;
@property(nonatomic,strong)NSArray *ability;
@property(nonatomic,readwrite)UIEdgeInsets edgeInset;

@end

@implementation YHDataView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.ability = @[@"成长",@"财值",@"情智",@"信念",@"工具"];
        self.edgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *icon = [[UIImageView alloc] init];
        self.iconImgView = icon;
        self.iconImgView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        
        UILabel *uname = [[UILabel alloc] init];
        self.unameLabel = uname;
        self.unameLabel.textAlignment = NSTextAlignmentCenter;
        self.unameLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0f];
        self.unameLabel.backgroundColor = [UIColor clearColor];
        
        UILabel *model = [[UILabel alloc] init];
        self.modelLabel = model;
        self.modelLabel.textAlignment = NSTextAlignmentCenter;
        self.modelLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
        self.modelLabel.backgroundColor = [UIColor clearColor];
        
        UILabel *accuData = [[UILabel alloc] init];
        self.accuLabel = accuData;
        self.accuLabel.textAlignment = NSTextAlignmentCenter;
        self.accuLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
        self.accuLabel.backgroundColor = [UIColor clearColor];
        
        UILabel *atteData = [[UILabel alloc] init];
        self.atteLabel = atteData;
        self.atteLabel.textAlignment = NSTextAlignmentCenter;
        self.atteLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
        self.atteLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制五角形
    CGPoint aPoint[6],bPoint[6],cPoint[2];
    CGFloat degree,present;
    CGFloat height = _edgeInset.top*3;
    CGFloat max_length = self.frame.size.height<self.frame.size.width/2?self.frame.size.height:self.frame.size.width/2;
    max_length = max_length<150?max_length:150;
    CGFloat length = (max_length-2*height)/(1+sin(PI*54/180));
    CGPoint CenterPoint = CGPointMake(self.frame.size.width/4, length+height+_edgeInset.top);
    length = (self.frame.size.width/4-2*height)/(cos(PI*26/180))<length?(self.frame.size.width/4-2*height)/(cos(PI*26/180)):length;
    CGFloat maxY = 0.0, minY = self.frame.size.height;
    
    cPoint[0] = CGPointMake(CenterPoint.x, CenterPoint.y);
    CGContextSetLineWidth(context, 0.6);
    [[UIColor grayColor] setStroke];
    for (NSInteger i = 0;i < 5;i++){
        degree = (72*fmod(i,5)/180 + 1)*PI;
        present = [self.capacity[i] floatValue]/10;
        if (present>1.0) {
            present = 1.0;
        }
        if (present<0.0) {
            present = 0.0;
        }
        cPoint[1] = CGPointMake(CenterPoint.x+length*sin(degree), CenterPoint.y+length*cos(degree));
        aPoint[i] = cPoint[1];
        bPoint[i] = CGPointMake(CenterPoint.x+length*sin(degree)*present, CenterPoint.y+length*cos(degree)*present);
        if (maxY < cPoint[1].y) {
            maxY = cPoint[1].y;
        }
        if (minY > cPoint[1].y) {
            minY = cPoint[1].y;
        }
        CGContextAddLines(context, cPoint, 2);
        CGContextDrawPath(context, kCGPathStroke);
        UILabel *abil = [[UILabel alloc] init];//能力标签
        abil.text = self.ability[i];
        abil.font = [UIFont fontWithName:@"STHeitiTC-Light" size:8.0f];
        abil.textAlignment = NSTextAlignmentCenter;
        UILabel *data = [[UILabel alloc] init];//能力标签
        data.text = [NSString stringWithFormat:@"%0.2f",[self.capacity[i] floatValue]];
        data.font = [UIFont fontWithName:@"STHeitiTC-Light" size:8.0f];
        data.textAlignment = NSTextAlignmentCenter;
        switch (i) {
            case 0:
                [abil setFrame:CGRectMake(cPoint[1].x, cPoint[1].y, -2*height, -height)];
                [data setFrame:CGRectMake(cPoint[1].x, cPoint[1].y,  2*height, -height)];
                break;
            case 1:
                [abil setFrame:CGRectMake(cPoint[1].x, cPoint[1].y, -2*height, -height)];
                [data setFrame:CGRectMake(cPoint[1].x, cPoint[1].y, -2*height,  height)];
                break;
            case 2:
                [abil setFrame:CGRectMake(cPoint[1].x, cPoint[1].y, -2*height,  height)];
                [data setFrame:CGRectMake(cPoint[1].x, cPoint[1].y,  2*height,  height)];
                break;
            case 3:
                [abil setFrame:CGRectMake(cPoint[1].x, cPoint[1].y, -2*height,  height)];
                [data setFrame:CGRectMake(cPoint[1].x, cPoint[1].y,  2*height,  height)];
                break;
            case 4:
                [abil setFrame:CGRectMake(cPoint[1].x, cPoint[1].y,  2*height, -height)];
                [data setFrame:CGRectMake(cPoint[1].x, cPoint[1].y,  2*height,  height)];
                break;
            default:
                [abil setFrame:CGRectZero];
                break;
        }
        [self addSubview:abil];
        [self addSubview:data];
    }
    aPoint[5] = aPoint[0];
    bPoint[5] = bPoint[0];
    CGContextSetLineWidth(context, 1.6);
    [[UIColor darkGrayColor] setStroke];
    CGContextAddLines(context, aPoint, 6);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetLineWidth(context, 1.2);
    [[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0  alpha:1.0] setStroke];
    [[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0  alpha:0.7] setFill];
    CGContextAddLines(context, bPoint, 6);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UILabel *inst = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, self.frame.size.width/2, self.frame.size.height-150)];
    inst.text = @"财富模型";
    inst.textAlignment = NSTextAlignmentCenter;
    inst.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0f];
    inst.backgroundColor = [UIColor clearColor];
    [self addSubview:inst];
    
    //绘制直线
    maxY += inst.frame.size.height;
    minY -= height;
    cPoint[0] = CGPointMake(self.frame.size.width/2, minY);
    cPoint[1] = CGPointMake(self.frame.size.width/2, maxY);
    CGContextSetLineWidth(context, 0.5);
    [[UIColor grayColor] setStroke];
    CGContextAddLines(context, cPoint, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGSize size = CGSizeMake(self.frame.size.width/2-4*self.edgeInset.left, ((cPoint[1].y-cPoint[0].y)/2 - 4*self.edgeInset.top)/2);
   
    CGRect cgrect = CGRectMake(self.frame.size.width/2+3*self.edgeInset.left, cPoint[0].y+self.edgeInset.left, size.width-self.edgeInset.right, (cPoint[1].y-cPoint[0].y)/3 - 2*self.edgeInset.bottom);
    
    //绘制头像
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_avatar]] placeholderImage:[UIImage imageNamed:@"imfomation_icon_default"]];
    [self.iconImgView setFrame:CGRectMake(cgrect.origin.x, cgrect.origin.y, cgrect.size.height, cgrect.size.height)];
    self.iconImgView.layer.cornerRadius = self.iconImgView.frame.size.width/2;
    self.iconImgView.clipsToBounds = YES;
    self.iconImgView.layer.borderWidth = 0.0f;
    self.iconImgView.layer.borderColor = [UIColor clearColor].CGColor;
    [self addSubview:_iconImgView];
    
    self.unameLabel.text = _uname;
    CGSize Size = [_unameLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [self.unameLabel setFrame:CGRectMake(cgrect.origin.x+cgrect.size.height+_edgeInset.right, cgrect.origin.y+cgrect.size.height/2-Size.height/2, Size.width, Size.height)];
    [self addSubview:_unameLabel];
    
    // 绘制进度条
    CGRect rectangle1 = CGRectMake(self.frame.size.width/2+2*self.edgeInset.left, cgrect.origin.y + cgrect.size.height+self.edgeInset.top, size.width, size.height);
    CGRect rectangle2 = CGRectMake(rectangle1.origin.x, rectangle1.origin.y+rectangle1.size.height+self.edgeInset.top*2,rectangle1.size.width, rectangle1.size.height);
    
    //标签
    [self.accuLabel setFrame:rectangle1];
    [self.atteLabel setFrame:rectangle2];
    UIColor *color = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    
    NSString *login = [NSString stringWithFormat:@"已登录%@天",_reg_all];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:login];
    [str1 addAttribute:NSForegroundColorAttributeName value:color range:[login rangeOfString:[NSString stringWithFormat:@"%@",_reg_all]]];
    [self addSubview:_accuLabel];
    
    NSString *question = [NSString stringWithFormat:@"已回答%@题",_question_count];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:question];
    [str2 addAttribute:NSForegroundColorAttributeName value:color range:[question rangeOfString:[NSString stringWithFormat:@"%@",_question_count]]];
    [self addSubview:_atteLabel];
    
    self.accuLabel.attributedText = str1;
    self.atteLabel.attributedText = str2;
    
    cgrect = CGRectMake(self.frame.size.width, inst.frame.origin.y, -inst.frame.size.width, self.frame.size.height-150);
    [self.modelLabel setFrame:cgrect];
    switch (_model.integerValue) {
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
    [self addSubview:_modelLabel];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
