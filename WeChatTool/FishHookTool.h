//
//  FishHookTool.h
//  WeChatTool
//
//  Created by walen on 16/11/23.
//
//

#import <Foundation/Foundation.h>

@interface FishHookTool : NSObject

+ (int)hookFuncNamed:(NSString *)funcName newAddress:(void *)newAdress oldAddress:(void **)replacement;

@end
