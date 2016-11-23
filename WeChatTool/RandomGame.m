
//
//  RandomGame.m
//  WeChatTool
//
//  Created by walen on 16/11/23.
//
//

#import "RandomGame.h"
#import "FishHookTool.h"
#import "NSObject+ZHAddForMethodSwizzing.h"

long myRandom(void);

long (*oldRandom)(void);

long myRandom(void)
{
    RandomType randomType = [GlobalConfig config].randomType;
    RandomDice randomDice = [GlobalConfig config].randomDice;
    RandomJkp  randomJkp = [GlobalConfig config].randomJkp;
    if (randomType == RandomTypeDice && randomDice != RandomDiceNone) {
        return randomDice - 1;
    }
    else if (randomType == RandomTypeJkp && randomJkp != RandomJkpNone) {
        return randomJkp - 1;
    }
    return oldRandom();
}

@implementation RandomGame

+ (void)randomSetup
{
    [self zh_swizzleClassWithName:@"GameController" classPrefix:@"Random_" methodPrefix:@"Random_"];
    [FishHookTool hookFuncNamed:@"random" newAddress:myRandom oldAddress:(void **)&oldRandom];
}

@end

@interface Random_GameController : UIViewController

@end

@implementation Random_GameController

- (void)Random_sendGameMessage:(id)arg1 toUsr:(id)arg2
{
    RandomDice randomDice = [GlobalConfig config].randomDice;
    RandomJkp  randomJkp = [GlobalConfig config].randomJkp;
    RandomType randomType = RandomTypeNone;
    
    id emotionWrap = arg1;
    unsigned int m_uiType = [[emotionWrap valueForKey:@"m_uiType"] unsignedIntValue];
    unsigned int m_uiGameType = [[emotionWrap valueForKey:@"m_uiGameType"] unsignedIntValue];
    
    if (m_uiType == 1 && m_uiGameType == 2 && randomDice != RandomDiceNone) {
        randomType = RandomTypeDice;
    }
    else if (m_uiType == 1 && m_uiGameType == 1 && randomJkp != RandomJkpNone) {
        randomType = RandomTypeJkp;
    }
    else
    {
        randomType = RandomTypeNone;
    }
    //设置randomType 让random函数去随机
    [GlobalConfig config].randomType = randomType;
    [self Random_sendGameMessage:arg1 toUsr:arg2];
    //恢复randomType字段
    [GlobalConfig config].randomType  = RandomTypeNone;
}

@end
