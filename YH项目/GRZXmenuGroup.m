//
//  GRZXmenuGroup.m
//  个人中心
//
//  Created by lab on 15/10/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GRZXmenuGroup.h"
#import "GRZXmenu.h"

@implementation GRZXmenuGroup

-(instancetype)initWithDict:(NSDictionary *)dict{

    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *sub_dict in self.groupContent) {
            GRZXmenu *menu = [GRZXmenu menuWithDict:sub_dict];
            [array addObject:menu];
        }
        self.groupContent = array;
    }
    return self;
}
+(instancetype)menugroupWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
