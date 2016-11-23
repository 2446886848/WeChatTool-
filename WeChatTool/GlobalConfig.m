//
//  GlobalConfig.m
//  WeChatTool
//
//  Created by walen on 16/10/14.
//
//

#import "GlobalConfig.h"

@implementation GlobalConfig

+ (instancetype)config
{
    static GlobalConfig *config  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.lockedKey = @"lockedKey";
    self.stepModeKey = @"stepModeKey";
    self.stepNumberKey = @"stepNumberKey";
    
    NSNumber *lockNum = [[NSUserDefaults standardUserDefaults] objectForKey:self.lockedKey];
    if (lockNum) {
        self.locked = [lockNum boolValue];
    }
    else
    {
        self.locked = YES;
    }
    
    self.stepMode = [[[NSUserDefaults standardUserDefaults] objectForKey:self.stepModeKey] integerValue];
    self.stepNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:self.stepNumberKey] floatValue];
    
    self.randomType = RandomTypeNone;
    self.randomDice = RandomDiceNone;
    self.randomJkp = RandomJkpNone;
}

- (void)setStepMode:(HeathStepMode)stepMode
{
    _stepMode = stepMode;
    //保存设置到沙盒
    [[NSUserDefaults standardUserDefaults] setObject:@(stepMode) forKey:self.stepModeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setStepNumber:(CGFloat)stepNumber
{
    _stepNumber = stepNumber;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(stepNumber) forKey:self.stepNumberKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    [[NSUserDefaults standardUserDefaults] setObject:@(locked) forKey:self.lockedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
