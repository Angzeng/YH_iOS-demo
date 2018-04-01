//
//  GRZXmenu.m
//  个人中心
//
//  Created by Apple on 15/10/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GRZXmenu.h"

@implementation GRZXmenu

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)menuWithDict:(NSDictionary *)dict{

    return [[self alloc] initWithDict:dict];
}

@end
