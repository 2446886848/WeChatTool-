//
//  RedEnvelop.h
//  WeChatTool
//
//  Created by walen on 16/10/9.
//
//

#import <Foundation/Foundation.h>

@interface RedEnvelop : NSObject

+ (void)setupAutoEnvelop;

@end

@class WCPayC2CMessageNodeView, CMessageNodeData, CMessageWrap, BaseMsgContentViewController, WCRedEnvelopesReceiveHomeView, WCRedEnvelopesRedEnvelopesDetailViewController;

@interface RedEnvelop_WCPayC2CMessageNodeView : UIView

- (BOOL)zh_isRedEnvelop;
- (BOOL)zh_isLastCell;

- (UITableViewCell *)zh_cell;

@end


@interface RedEnvelop_CMessageWrap : NSObject

@end

@interface RedEnvelop_BaseMsgContentViewController : UIViewController

@end

@interface RedEnvelop_WCRedEnvelopesReceiveHomeView : UIView

@end

@interface RedEnvelop_WCRedEnvelopesRedEnvelopesDetailViewController : UIViewController

@end
