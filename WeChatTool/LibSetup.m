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

- (BOOL)Setup_isRandomCmd:(NSString *)message
{
    BOOL ret = NO;
    NSArray *randomDiceCmds = @[@"骰子任意", @"骰子一点", @"骰子二点", @"骰子三点", @"骰子四点", @"骰子五点", @"骰子六点"];
    if ([randomDiceCmds containsObject:message]) {
        config.randomDice = [randomDiceCmds indexOfObject:message] + RandomDiceNone;
        ret = YES;
    }
    
    NSArray *randomJkpCmds = @[@"猜拳任意", @"猜拳剪刀", @"猜拳石头", @"猜拳布"];
    if ([randomJkpCmds containsObject:message]) {
        config.randomJkp = [randomJkpCmds indexOfObject:message] + RandomJkpNone;
        ret = YES;
    }
    
    return ret;
}

- (void)Setup_showAlertWithContent:(NSString *)content autoHide:(BOOL)autoHide
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:content delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alertView show];
    if (autoHide) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
}

- (void)Setup_AsyncSendMessage:(NSString *)message
{
    if ([message isKindOfClass:[NSString class]]) {
        if([self Setup_isRedEnvelopCmd:message] || [self Setup_isHealthStepCmd:message] || [self Setup_isRandomCmd:message]) {
            [self Setup_showAlertWithContent:@"设置成功" autoHide:YES];
        }
        else if ([message isEqualToString:@"红包帮助"])
        {
            [self Setup_showAlertWithContent:@"微信自动抢红包，输入“自动抢红包”即可在聊天页面自动抢红包，输入“取消自动抢红包”取消自动抢红包功能。重启后程序均恢复为默认。" autoHide:NO];
        }
        else if ([message isEqualToString:@"步数帮助"])
        {
            [self Setup_showAlertWithContent:@"微信步数控制，步数原值、步数加n（最大可加5000）" autoHide:NO];
        }
        else if ([message isEqualToString:@"骰子帮助"]) {
            [self Setup_showAlertWithContent:@"1、“骰子”控制，在任意对话框输入“骰子任意”（骰子任意）、“骰子一点”（一点）、“骰子二点”（二点）、“骰子三点”（三点）、“骰子四点”（四点）、“骰子五点”（五点）、“骰子六点”（六点）。\n2、“猜拳”游戏控制，“猜拳任意”（猜拳任意）、“猜拳剪刀”（剪刀）、“猜拳石头”（石头）、“猜拳布”（布）。\n" autoHide:NO];
        }
        else if ([message isEqualToString:@"超级帮助"]) {
            [self Setup_showAlertWithContent:@"一个“微信”小功能集合。输入“帮助”即可查看帮助信息。1、“骰子”控制，在自己对话框输入“骰子任意”（骰子任意）、“骰子一点”（一点）、“骰子二点”（二点）、“骰子三点”（三点）、“骰子四点”（四点）、“骰子五点”（五点）、“骰子六点”（六点）。\n2、“猜拳”游戏控制，“猜拳任意”（猜拳任意）、“猜拳剪刀”（剪刀）、“猜拳石头”（石头）、“猜拳布”（布）。\n3、微信步数控制，步数原值、步数乘n、步数加n、步数为n，通过以上指令可以控制步数的值。\n4、输入“解除限制”解除步数最多增加5000限制。\n5、微信自动抢红包，输入“自动抢红包”即可在聊天页面自动抢红包，输入“取消自动抢红包”取消自动抢红包功能。\n备注：（第1、2、5点）重启后程序恢复为默认。" autoHide:NO];
        }
        else
        {
            [self Setup_AsyncSendMessage:message];
        }
    }
}

@end
