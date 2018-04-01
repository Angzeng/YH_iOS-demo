//
//  GRZXmenuGroup.h
//  个人中心
//
//  Created by lab on 15/10/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRZXmenuGroup : NSObject

@property (nonatomic,strong) NSArray *groupContent;


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)menugroupWithDict:(NSDictionary *)dict;

@end
