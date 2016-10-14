//
//  RedEnvelop.m
//  WeChatTool
//
//  Created by walen on 16/10/9.
//
//

#import "RedEnvelop.h"
#import <objc/runtime.h>

static GlobalConfig *config = nil;

@interface NSObject (RedEnvelop)
@property (nonatomic, strong) NSNumber *redEnvelopTag;
@end
@implementation NSObject (RedEnvelop)

- (NSNumber *)redEnvelopTag
{
    return objc_getAssociatedObject(self, @selector(redEnvelopTag));
}

- (void)setRedEnvelopTag:(NSNumber *)redEnvelopTag
{
    objc_setAssociatedObject(self, @selector(redEnvelopTag), redEnvelopTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface UIView (RedEnvelop)

- (UIViewController *)zh_vc;

@end

@implementation UIView (RedEnvelop)

- (UIViewController *)zh_vc
{
    UIResponder *responder = self;
    while(responder)
    {
        if([responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end

@class WCPayC2CMessageNodeView, CMessageNodeData, CMessageWrap, BaseMsgContentViewController, WCRedEnvelopesReceiveHomeView, WCRedEnvelopesRedEnvelopesDetailViewController;

@implementation RedEnvelop

+ (void)setupAutoEnvelop
{
    config = [GlobalConfig config];
    
    [NSObject zh_swizzleClassWithName:@"WCPayC2CMessageNodeView" classPrefix:@"RedEnvelop_" methodPrefix:@"zh_"];
    [NSObject zh_swizzleClassWithName:@"CMessageWrap" classPrefix:@"RedEnvelop_" methodPrefix:@"zh_"];
    [NSObject zh_swizzleClassWithName:@"BaseMsgContentViewController" classPrefix:@"RedEnvelop_" methodPrefix:@"zh_"];
    
    [NSObject zh_swizzleClassWithName:@"WCRedEnvelopesReceiveHomeView" classPrefix:@"RedEnvelop_" methodPrefix:@"zh_"];
    [NSObject zh_swizzleClassWithName:@"WCRedEnvelopesRedEnvelopesDetailViewController" classPrefix:@"RedEnvelop_" methodPrefix:@"zh_"];
    
}

@end

@implementation RedEnvelop_CMessageWrap

- (BOOL)zh_isMessageFromMe
{
    static NSString *selfUserName = nil;
    if (!selfUserName) {
        Method methodMMServiceCenter = class_getClassMethod(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
        IMP impMMSC = method_getImplementation(methodMMServiceCenter);
        id MMServiceCenter = ((id(*)(Class, SEL))impMMSC)(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
        //通讯录管理器
        id contactManager = [MMServiceCenter performSelector:@selector(getService:) withObject:objc_getClass("CContactMgr")];
        id selfContact = [contactManager performSelector:@selector(getSelfContact)];
        selfUserName = [selfContact valueForKey:@"m_nsUsrName"];
    }
    
    NSString *m_nsFromUsr = [self valueForKey:@"m_nsFromUsr"];
    
    BOOL isMesasgeFromMe = [m_nsFromUsr isEqualToString:selfUserName];
    
    return isMesasgeFromMe;
}
@end

@implementation RedEnvelop_WCPayC2CMessageNodeView

- (void)zh_layoutSubviews
{
    [self zh_layoutSubviews];
    if (self.redEnvelopTag || !config.autoRedEnvOpen) {
        return;
    }
    
    else {
        RedEnvelop_CMessageWrap *msg = (RedEnvelop_CMessageWrap *)[self valueForKey:@"m_oMessageWrap"];
        //消息来自于自己的单聊不处理
        
        BOOL isFromMe = [msg zh_isMessageFromMe];
        if (isFromMe && ![[[[self zh_vc] performSelector:@selector(GetContact)] valueForKey:@"m_nsUsrName"] containsString:@"@chatroom"])
        {
            return;
        }
        if([self zh_isLastCell] && [self zh_isRedEnvelop]) {
            config.isInAutoRedEnvOpening = YES;
            self.redEnvelopTag = @(YES);
            [self performSelector:@selector(onClick)];
        }
    }
}

- (BOOL)zh_isRedEnvelop
{
    id msg = [self valueForKey:@"m_oMessageWrap"];
    return [[msg valueForKey:@"m_uiMessageType"] integerValue] == 49;
}

- (BOOL)zh_isLastCell
{
    UIViewController *vc = [self zh_vc];
    if([vc isKindOfClass:[NSClassFromString(@"BaseMsgContentViewController") class]]) {
        NSMutableArray<CMessageNodeData *> *nodeDatas = [vc valueForKey:@"m_arrMessageNodeData"];
        id lastNodeData = nodeDatas.lastObject;
        CMessageWrap *msg = [self valueForKey:@"m_oMessageWrap"];
        return [lastNodeData valueForKey:@"m_msgWrap"] == msg;
    }
    return NO;
}

- (UITableViewCell *)zh_cell
{
    UIView *view = self;
    while(view)
    {
        if([view isKindOfClass:[UITableViewCell class]])
        {
            return (UITableViewCell *)view;
        }
        view = [view superview];
    }
    return nil;
}

@end

@implementation RedEnvelop_BaseMsgContentViewController

- (void)zh_viewDidDisappear:(BOOL)animated
{
    [self zh_viewDidDisappear:animated];
    config.isInAutoRedEnvOpening = NO;
}

@end

@implementation RedEnvelop_WCRedEnvelopesReceiveHomeView

- (void)zh_layoutSubviews
{
    [self zh_layoutSubviews];
    
    if (config.isInAutoRedEnvOpening && !self.redEnvelopTag)
    {
        UIButton *openButton = [self valueForKey:@"openRedEnvelopesButton"];
        if (openButton.hidden)
        {
            config.isInAutoRedEnvOpening = NO;
            [self performSelector:@selector(OnCancelButtonDone)];
        }
        else
        {
            [self performSelector:@selector(OnOpenRedEnvelopes)];
        }
    }
    self.redEnvelopTag = @(YES);
}

@end

@implementation RedEnvelop_WCRedEnvelopesRedEnvelopesDetailViewController

- (void)zh_setLeftCloseBarButton
{
    [self zh_setLeftCloseBarButton];
    
    if (config.isInAutoRedEnvOpening) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            config.isInAutoRedEnvOpening = NO;
            [self performSelector:@selector(OnLeftBarButtonDone)];
        });
    }
}

@end
