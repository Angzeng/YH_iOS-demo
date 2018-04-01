//
//  YHMessage.m
//  YH项目
//
//  Created by Angzeng on 27/07/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "YHMessage.h"

@implementation YHMessage

- (instancetype)initWithType:(RCConversationType)conversationType
                      targetId:(NSString *)targetId
                     direction:(RCMessageDirection)messageDirection
                     messageId:(long)messageId
                       content:(RCMessageContent *)content {
    NSLog(@"%@",content);
    YHMessage *ttt = [[YHMessage alloc] init];
    return ttt;
}

@end
