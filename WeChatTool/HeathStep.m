//
//  HeathStep.m
//  WeChatTool
//
//  Created by walen on 16/10/14.
//
//

#import "HeathStep.h"
#import <HealthKit/HealthKit.h>

static GlobalConfig *config = nil;

double changedStepCount(double oldStepCount);

double changedStepCount(double oldStepCount) {
    double ret = oldStepCount;
    switch (config.stepMode) {
        case HeathStepModeNone:
            break;
        case HeathStepModeMutiply:
            ret = (unsigned int)(ret * config.stepNumber);
            break;
        case HeathStepModeAdd:
            ret += config.stepNumber;
            break;
        case HeathStepModeSet:
            ret = config.stepNumber;
            break;
        default:
            break;
    }
    
    if (config.locked) {
        if (ret - oldStepCount > 5000) {
            ret = oldStepCount + 5000;
        }
    }
    return ret;
}

@interface HeathStep_HKStatistics : HKStatistics

@end

@implementation HeathStep_HKStatistics

- (HKQuantity *)HeathStep_sumQuantity
{
    HKQuantity *quantity = [self HeathStep_sumQuantity];
    
    HKUnit *unit = [quantity valueForKey:@"_unit"];
    double value = [quantity doubleValueForUnit:unit];
    HKQuantity *newQuantity = [HKQuantity quantityWithUnit:unit doubleValue:changedStepCount(value)];
    
    return newQuantity;
}

@end

@implementation HeathStep

+ (void)setupHealthStep
{
    config = [GlobalConfig config];
    
    [NSObject zh_swizzleClassWithName:@"HKStatistics" classPrefix:@"HeathStep_" methodPrefix:@"HeathStep_"];
}

@end
