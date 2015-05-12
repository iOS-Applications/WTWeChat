//
//  WTXMPPTool.h
//  WTWeChat
//
//  Created by 张威庭 on 15/5/9.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"

extern NSString *const WTLoginStatusChangeNotification;

typedef enum{
    XMPPResultTypeConnecting,//连接中...
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败

    XMPPResultTypeNetErr,//网络不给力
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
    
}XMPPResultType;

typedef void (^XMPPResultBlock)(XMPPResultType type);//XMPP请求结果的block




@interface WTXMPPTool : NSObject<XMPPStreamDelegate>

singleton_interface(WTXMPPTool)

@property (nonatomic,strong,readonly)  XMPPStream *xmppStream;
/**
 *  电子名片
 */
@property (nonatomic, strong,readonly)XMPPvCardTempModule *vCard;

/**
 *  花名册模块
 */
@property (nonatomic, strong,readonly)XMPPRosterCoreDataStorage *rosterStorage;
/**
 *  花名册数据存储
 */
@property (nonatomic, strong,readonly)XMPPRoster *roster;
/**
 *  聊天的数据存储
 */
@property (nonatomic, strong,readonly)XMPPMessageArchivingCoreDataStorage *msgStorage;
/**
 *  注册标识 YES 注册/NO 登录
 */
@property (nonatomic,assign,getter=isRegisterOperation) BOOL registerOperation;
/**
 *  注销
 */
-(void)xmppUserlogout;
/**
 *  用户登录
 */
-(void)xmppUserLogin:(XMPPResultBlock)resultBlock;

/**
 *  用户注册
 *
 *  @param resultBlock
 */
-(void)xmppUserRegister:(XMPPResultBlock)resultBlock;

@end
