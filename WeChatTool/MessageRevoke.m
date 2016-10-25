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

@implementation MessageRevoke

+ (void)setupMessage
{
    [NSObject zh_swizzleClassWithName:@"CMessageMgr" classPrefix:@"MessageRevoke_" methodPrefix:@"MessageRevoke_"];
}

@end
