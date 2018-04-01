//
//  YHMessageContent.h
//  YH项目
//
//  Created by Angzeng on 27/07/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface YHMessageContent : RCMessageContent <NSCoding,RCMessageContentView>
/** 文本消息内容 */
@property(nonatomic, strong) NSString* content;

/**
 * 附加信息
 */
@property(nonatomic, strong) NSString* extra;

/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end
