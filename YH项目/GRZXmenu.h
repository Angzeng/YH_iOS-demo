//
//  GRZXmenu.h
//  个人中心
//
//  Created by Apple on 15/10/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRZXmenu : NSObject

@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *title;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)menuWithDict:(NSDictionary *)dict;

@end
