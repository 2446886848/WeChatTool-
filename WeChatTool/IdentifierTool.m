//
//  IdentifierTool.m
//  WeChatTool
//
//  Created by walen on 16/11/23.
//
//

#import "IdentifierTool.h"
#import "NSObject+ZHAddForMethodSwizzing.h"

@interface Hooked_NSBundle : NSBundle

@end

@implementation Hooked_NSBundle

- (NSDictionary<NSString *,id> *)Hooked_infoDictionary
{
    NSMutableDictionary *infoDictionary = (NSMutableDictionary *)[self Hooked_infoDictionary];
    if (self == [NSBundle mainBundle]) {
        static NSString *identifier = @"com.tencent.xin";
        static NSString *identifierKey = @"CFBundleIdentifier";
        
        if (![infoDictionary[identifierKey] isEqualToString:identifier]) {
            infoDictionary[identifierKey] = identifier;
        }
    }
    return infoDictionary;
}

@end

@implementation IdentifierTool

+ (void)setupIdentifier
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
        [dic setValue:@"com.tencent.xin" forKey:@"CFBundleIdentifier"];
    });
//    [self zh_swizzleClassWithName:@"NSBundle" classPrefix:@"Hooked_" methodPrefix:@"Hooked_"];
}

@end
