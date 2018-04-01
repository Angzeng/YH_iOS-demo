//
//  textFieldBackground.m
//  YHLogin
//
//  Created by Apple on 16/4/21.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "addtextFieldBackground.h"

@implementation addtextFieldBackground

- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,0.2);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 5, 50);
    CGContextAddLineToPoint(context,self.frame.size.width-5, 50);
    CGContextMoveToPoint(context, 5, 100);
    CGContextAddLineToPoint(context,self.frame.size.width-5, 100);
    CGContextClosePath(context);
    [[UIColor grayColor] setStroke];
    CGContextStrokePath(context);
}




@end

