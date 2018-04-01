//
//  GRZXuser.m
//  个人中心
//
//  Created by Apple on 15/10/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GRZXuser.h"

@implementation GRZXuser

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithName:(NSString *)name work:(NSString *)work address:(NSString *)addr icon:(NSString *)icon phoneNumber:(NSString *)phone age:(NSString *)age andSex:(NSString *)sex{
    self.name = name;
    self.work = work;
    self.address = addr;
    self.icon = icon;
    self.phoneNumber = phone;
    self.age = [age integerValue];
    self.sex = [sex integerValue];

    return self;
}
+(instancetype)userWithName:(NSString *)name work:(NSString *)work address:(NSString *)addr icon:(NSString *)icon phoneNumber:(NSString *)phone age:(NSString *)age andSex:(NSString *)sex{
    return [[self alloc] initWithName:name work:work address:addr icon:icon phoneNumber:phone age:age andSex:sex];
}
@end
