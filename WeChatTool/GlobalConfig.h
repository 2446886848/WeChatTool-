//
//  GlobalConfig.h
//  WeChatTool
//
//  Created by walen on 16/10/14.
//
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HeathStepModeNone,
    HeathStepModeMutiply,
    HeathStepModeAdd,
    HeathStepModeSet,
} HeathStepMode;

typedef NS_ENUM(NSUInteger, RandomDice) {
    RandomDiceNone = 0,
    RandomDiceOne,
    RandomDiceTwo,
    RandomDiceThree,
    RandomDiceFour,
    RandomDiceFive,
    RandomDiceSix,
};

typedef NS_ENUM(NSUInteger, RandomJkp) {
    RandomJkpNone = 0,
    RandomJkpJianDao,
    RandomJkpShiTou,
    RandomJkpBu,
};

typedef NS_ENUM(NSUInteger, RandomType) {
    RandomTypeNone,
    RandomTypeDice,
    RandomTypeJkp,
};

@interface GlobalConfig : NSObject

+ (instancetype)config;

//红包
@property (nonatomic, assign) BOOL autoRedEnvOpen;
@property (nonatomic, assign) BOOL isInAutoRedEnvOpening;

//步数
@property (nonatomic, copy) NSString *lockedKey;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, assign) HeathStepMode stepMode;
@property (nonatomic, assign) CGFloat stepNumber;
@property (nonatomic, copy) NSString *stepModeKey;
@property (nonatomic, copy) NSString *stepNumberKey;

//骰子
@property (nonatomic, assign) RandomType randomType;
@property (nonatomic, assign) RandomDice randomDice;
@property (nonatomic, assign) RandomJkp randomJkp;

//取消本次消息的发送 仅仅生效一次
@property (nonatomic, assign) BOOL cancleMessageSend;

@end
