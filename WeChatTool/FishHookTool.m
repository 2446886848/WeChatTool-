//
//  FishHookTool.m
//  WeChatTool
//
//  Created by walen on 16/11/23.
//
//

#import "FishHookTool.h"
#import "fishhook.h"
int hook(NSString *name, void *replacement, void **replaced);

int hook(NSString *name, void *replacement, void **replaced)
{
    return rebind_symbols((struct rebinding[1]){{name.UTF8String, replacement, (void *)replaced}}, 1);
}

@implementation FishHookTool

+ (int)hookFuncNamed:(NSString *)funcName newAddress:(void *)newAdress oldAddress:(void **)replacement
{
    return hook(funcName, newAdress, replacement);
}

@end
