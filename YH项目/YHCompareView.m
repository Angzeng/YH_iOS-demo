//
//  YHCompareView.m
//  YH项目
//
//  Created by zhujinchi on 16/7/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YHCompareView.h"
#import "YHLoginViewController.h"
#define PI 3.14159265358979323846

@interface YHCompareView()

@property(nonatomic,strong)NSArray *ability;
@property(nonatomic,readwrite)UIEdgeInsets edgeInset;

@end

@implementation YHCompareView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.ability = @[@"成长",@"财值",@"情智",@"信念",@"工具"];
        self.edgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制五角形-left
    CGPoint aPoint[6],bPoint[6],cPoint[2];
    CGFloat degree,present;
    CGFloat height = _edgeInset.top*3;
    CGFloat length = (self.frame.size.height-2*height)/(1+sin(PI*54/180));
    CGPoint CenterPoint = CGPointMake(self.frame.size.width/4, length+height);
    length = (self.frame.size.width/4-2*height)/(cos(PI*26/180))<length?(self.frame.size.width/4-2*height)/(cos(PI*26/180)):length;
//    CGFloat maxY = 0.0, minY = self.frame.size.height;
    
    cPoint[0] = CGPointMake(CenterPoint.x, CenterPoint.y);
    CGContextSetLineWidth(context, 0.6);
    [[UIColor grayColor] setStroke];
    for (NSInteger i = 0;i < 5;i++){
        degree = (72*fmod(i,5)/180 + 1)*PI;
        present = [self.capacityOfCelebrity[i] floatValue]/10;
        cPoint[1] = CGPointMake(CenterPoint.x+length*sin(degree), CenterPoint.y+length*cos(degree));
        aPoint[i] = cPoint[1];
        bPoint[i] = CGPointMake(CenterPoint.x+length*sin(degree)*present, CenterPoint.y+length*cos(degree)*present);
//        if (maxY < cPoint[1].y) {
//            maxY = cPoint[1].y;
//        }
//        if (minY > cPoint[1].y) {
//            minY = cPoint[1].y;
//        }
        CGContextAddLines(context, cPoint, 2);
        CGContextDrawPath(context, kCGPathStroke);
        UILabel *abil = [[UILabel alloc] init];//能力标签
        abil.text = self.ability[i];
        abil.font = [UIFont fontWithName:@"STHeitiTC-Light" size:8.0f];
        abil.textAlignment = NSTextAlignmentCenter;
        UILabel *data = [[UILabel alloc] init];
        data.text = [NSString stringWithFormat:@"%0.2f",[self.capacityOfCelebrity[i] floatValue]];
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
    
    
    //绘制五角形-right
    CenterPoint = CGPointMake(self.frame.size.width*3/4, CenterPoint.y);
    //    CGFloat maxY = 0.0, minY = self.frame.size.height;
    
    cPoint[0] = CGPointMake(CenterPoint.x, CenterPoint.y);
    CGContextSetLineWidth(context, 0.6);
    [[UIColor grayColor] setStroke];
    for (NSInteger i = 0;i < 5;i++){
        degree = (72*fmod(i,5)/180 + 1)*PI;
        present = [YHCapacityOfUser[i] floatValue]/10;
        cPoint[1] = CGPointMake(CenterPoint.x+length*sin(degree), CenterPoint.y+length*cos(degree));
        aPoint[i] = cPoint[1];
        bPoint[i] = CGPointMake(CenterPoint.x+length*sin(degree)*present, CenterPoint.y+length*cos(degree)*present);
        //        if (maxY < cPoint[1].y) {
        //            maxY = cPoint[1].y;
        //        }
        //        if (minY > cPoint[1].y) {
        //            minY = cPoint[1].y;
        //        }
        CGContextAddLines(context, cPoint, 2);
        CGContextDrawPath(context, kCGPathStroke);
        UILabel *abil = [[UILabel alloc] init];//能力标签
        abil.text = self.ability[i];
        abil.font = [UIFont fontWithName:@"STHeitiTC-Light" size:8.0f];
        abil.textAlignment = NSTextAlignmentCenter;
        UILabel *data = [[UILabel alloc] init];
        data.text = [NSString stringWithFormat:@"%0.2f",[YHCapacityOfUser[i] floatValue]];
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
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
