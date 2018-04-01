//
//  GRZXcollect.m
//  个人中心
//
//  Created by Apple on 15/11/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "GRZXcollect.h"

@implementation GRZXcollect

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return  self;
}

+(instancetype)collectWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}


@end
