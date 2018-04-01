//
//  YHInfoDataView.m
//  YH项目
//
//  Created by yaojie he on 2017/3/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YHInfoDataView.h"
#define PI 3.14159265358979323846

@interface YHInfoDataView()

@property(nonatomic,strong) NSArray *capacity;
@property(nonatomic,strong) NSArray *ability;

@end

@implementation YHInfoDataView

-(id)initWithFrame:(CGRect)frame WithData:(NSArray*) capacity{
    self = [super initWithFrame:frame];
    if (self) {
        _capacity = capacity;
         _ability = @[@"成长",@"财值",@"情智",@"信念",@"工具"];
    }
    return self;
}

-(void) drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
    
    //绘制五角形
    CGPoint aPoint[6],bPoint[6],cPoint[2];
    CGFloat degree,present;
    CGFloat height = 12;
    CGFloat max_length = self.frame.size.height<self.frame.size.width?self.frame.size.height:self.frame.size.width;
    CGFloat length = (max_length-2*height)/(1+sin(PI*54/180));
    CGPoint CenterPoint = CGPointMake(self.frame.size.width/2, length+2*height);
    length = (self.frame.size.width/2-2*height)/(cos(PI*26/180))<length?(self.frame.size.width/2-2*height)/(cos(PI*26/180)):length;
    
    
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
    CGContextSetLineWidth(context, 1.4);
    [[UIColor darkGrayColor] setStroke];
    CGContextAddLines(context, aPoint, 6);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetLineWidth(context, 1.0);
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
