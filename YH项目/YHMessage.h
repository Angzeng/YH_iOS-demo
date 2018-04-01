//
//  YHMessage.h
//  YH项目
//
//  Created by Angzeng on 27/07/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import "YHMessageContent.h"

@interface YHMessage : RCMessage

@property(nonatomic, strong) YHMessageContent *yhcontent;

//- (instancetype)initWithType:(RCConversationType)conversationType
//                    targetId:(NSString *)targetId
//                   direction:(RCMessageDirection)messageDirection
//                   messageId:(long)messageId
//                     content:(RCMessageContent *)content;

@end
