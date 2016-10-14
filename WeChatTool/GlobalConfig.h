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

@end
