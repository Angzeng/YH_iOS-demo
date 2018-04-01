//
//  GRZXcollect.h
//  个人中心
//
//  Created by Apple on 15/11/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRZXcollect : NSObject

@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)collectWithDict:(NSDictionary *)dict;

@end
