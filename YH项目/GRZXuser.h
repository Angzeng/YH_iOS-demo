//
//  GRZXuser.h
//  个人中心
//
//  Created by Apple on 15/10/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GRZXuser : NSObject

@property (nonatomic,assign) NSInteger age;
@property (nonatomic,assign) NSInteger sex;

@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *work;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *phoneNumber;

-(instancetype)initWithName:(NSString *)name work:(NSString *)work address:(NSString *)addr icon:(NSString *)icon phoneNumber:(NSString *)phone age:(NSString *)age andSex:(NSString *)sex;
+(instancetype)userWithName:(NSString *)name work:(NSString *)work address:(NSString *)addr icon:(NSString *)icon phoneNumber:(NSString *)phone age:(NSString *)age andSex:(NSString *)sex;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)userWithDict:(NSDictionary *)dict;

@end
