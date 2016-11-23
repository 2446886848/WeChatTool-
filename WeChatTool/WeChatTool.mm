//
//  WeChatTool.m
//  WeChatTool
//
//  Created by walen on 16/9/29.
//  Copyright (c) 2016年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedEnvelop.h"
#import "HeathStep.h"
#import "MessageRevoke.h"
#import "RandomGame.h"
#import "IdentifierTool.h"

__attribute__((constructor)) static void entry()
{
    [IdentifierTool setupIdentifier];
    [LibSetup setup];
    [RedEnvelop setupAutoEnvelop];
    [HeathStep setupHealthStep];
    [MessageRevoke setupMessage];
    [RandomGame randomSetup];
}
