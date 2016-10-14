//
//  LibSetup.m
//  WeChatTool
//
//  Created by walen on 16/10/14.
//
//

#import "LibSetup.h"

static GlobalConfig *config = nil;

@interface Setup_BaseMsgContentViewController : UIViewController

@end

@implementation LibSetup

+ (void)setup
{
    [NSObject zh_swizzleClassWithName:@"BaseMsgContentViewController" classPrefix:@"Setup_" methodPrefix:@"Setup_"];
    config = [GlobalConfig config];
}

@end

@implementation Setup_BaseMsgContentViewController

- (BOOL)Setup_isHealthStepCmd:(NSString *)messageText
{
    BOOL isCmd = NO;
    NSString *setpOriStr = @"步数原值";
    NSString *setpAddStr = @"步数加";
    NSString *setpMulStr = @"步数乘";
    NSString *setpIsStr = @"步数为";
    if ([messageText containsString:setpAddStr]) {
        isCmd = YES;
        NSString *numberStr = [messageText substringFromIndex:setpAddStr.length];
        config.stepNumber = [numberStr integerValue];
        config.stepMode = HeathStepModeAdd;
    }
    if ([messageText containsString:setpMulStr]) {
        isCmd = YES;
        NSString *numberStr = [messageText substringFromIndex:setpMulStr.length];
        config.stepNumber = [numberStr doubleValue];
        config.stepMode = HeathStepModeMutiply;
    }
    if ([messageText containsString:setpIsStr]) {
        isCmd = YES;
        NSString *numberStr = [messageText substringFromIndex:setpIsStr.length];
        config.stepNumber = [numberStr integerValue];
        config.stepMode = HeathStepModeSet;
    }
    if ([messageText containsString:setpOriStr]) {
        isCmd = YES;
        config.stepMode = HeathStepModeNone;
    }
    
    if ([messageText isEqualToString:@"解除限制"])
    {
        config.locked = NO;
    }
    return isCmd;
}


- (BOOL)Setup_isRedEnvelopCmd:(NSString *)message
{
    if ([message isEqualToString:@"自动抢红包"]) {
        config.autoRedEnvOpen = YES;
        return  YES;
    }
    if ([message isEqualToString:@"取消自动抢红包"]) {
        config.autoRedEnvOpen = NO;
        return  YES;
    }
    return NO;
}

- (void)Setup_AsyncSendMessage:(NSString *)message
{
    if ([message isKindOfClass:[NSString class]]) {
        if([self Setup_isRedEnvelopCmd:message] || [self Setup_isHealthStepCmd:message]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置成功" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alertView show];
        }
        else if ([message isEqualToString:@"红包帮助"])
        {
            [self Setup_AsyncSendMessage:@"微信自动抢红包，输入“自动抢红包”即可在聊天页面自动抢红包，输入“取消自动抢红包”取消自动抢红包功能。重启后程序均恢复为默认。"];
        }
        else if ([message isEqualToString:@"步数帮助"])
        {
            [self Setup_AsyncSendMessage:@"微信步数控制，步数原值、步数加n（最大为5000）"];
        }
        else if ([message isEqualToString:@"超级帮助"]) {
            [self Setup_AsyncSendMessage:@"一个“微信”小功能集合。输入“帮助”即可查看帮助信息。\n  \n  1、微信步数控制，步数原值、步数乘n、步数加n、步数为n，通过以上指令可以控制步数的值。\n  2、输入“解除控制”解除步数的增加5000限制。\n  3、微信自动抢红包，输入“自动抢红包”即可在聊天页面自动抢红包，输入“取消自动抢红包”取消自动抢红包功能。\n  备注：（第3点）重启后程序恢复为默认。"];
        }
        else
        {
            [self Setup_AsyncSendMessage:message];
        }
    }
}

@end
