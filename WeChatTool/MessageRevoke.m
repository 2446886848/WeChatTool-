//
//  MessageRevoke.m
//  WeChatTool
//
//  Created by walen on 16/10/24.
//
//

#import "MessageRevoke.h"

@interface MessageRevoke_CMessageMgr : NSObject

@end

@implementation MessageRevoke_CMessageMgr

- (void)MessageRevoke_DelMsg:(NSString *)arg1 MsgList:(NSArray *)arg2 DelAll:(BOOL)arg3{}

@end

@interface MessageCancle_SendMessageMgr : NSObject

@end

@implementation MessageCancle_SendMessageMgr

- (void)MessageCancle_AddMsgToSendTable:(id)arg1 MsgWrap:(id)arg2
{
    GlobalConfig *config = [GlobalConfig config];
    if (!config.cancleMessageSend) {
        [self MessageCancle_AddMsgToSendTable:arg1 MsgWrap:arg2];
    }
    config.cancleMessageSend = NO;
}

@end

@implementation MessageRevoke

+ (void)setupMessage
{
    [self zh_swizzleClassWithName:@"SendMessageMgr" classPrefix:@"MessageCancle_" methodPrefix:@"MessageCancle_"];
    [NSObject zh_swizzleClassWithName:@"CMessageMgr" classPrefix:@"MessageRevoke_" methodPrefix:@"MessageRevoke_"];
}

@end
