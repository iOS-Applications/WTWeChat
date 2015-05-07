//
//  AppDelegate.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/5.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
/**
 *  在AppDelegate实现登录
 1.初始化XMPPStream
 2.连接到服务器(传一个JID)
 3.连接到服务成功后,再发送密码授权
 4.授权成功后,发送"在线"消息
 */
@interface AppDelegate ()<XMPPStreamDelegate>
{
    XMPPStream *_xmppStream;

}
/**
 *   1.初始化XMPPStream
 */
-(void)setupXMPPStream;
/**
 *  2.连接到服务器(传一个JID)
 */
-(void)connectToHost;
/**
 *  3.连接到服务成功后,再发送密码授权
 */
-(void)sendPwdToHost;
/**
 *  4.授权成功后,发送"在线"消息
 */
-(void)sendOnlineToHost;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //程序一启动就连接到主机
    [self connectToHost];
    return YES;
}


#pragma mark -私有方法
#pragma mark 初始化XMPPSteam
-(void)setupXMPPStream{
    _xmppStream = [[XMPPStream alloc] init];
    
      //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}
#pragma mark 连接到服务器(传一个JID)
-(void)connectToHost{
    WTLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    //设置登录用户JID
    //resource 标识用户登录的客户端 iPhone Android
    XMPPJID *myJID=[XMPPJID jidWithUser:@"zhangweiting" domain:@"zhangweiting.local" resource:@"iphone"];
    
    _xmppStream.myJID=myJID;
    
    //设置服务器域名
    _xmppStream.hostName=@"zhangweiting.local";//不仅可以是域名,还可以使IP地址127.0.0.1

    //设置端口 如果服务器端口是5222,可以省略
    _xmppStream.hostPort=5222;
    
    //连接
    NSError *err =nil;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]){
        WTLog(@"%@",err);
    }
    
    
}
#pragma mark 连接到服务器成功后,再发送密码授权
-(void)sendPwdToHost{
    WTLog(@"再发送密码授权");
    NSError *err=nil;
    [_xmppStream authenticateWithPassword:@"123456" error:&err];
    if (err) {
        WTLog(@"%@",err);
    }
    
}

#pragma mark 授权成功后,发送"在线"消息
-(void)sendOnlineToHost{
    WTLog(@"发送在线消息");
    XMPPPresence *presence=[XMPPPresence presence];
    [_xmppStream sendElement:presence];
    
}



#pragma mark -XMPPStream的代理

#pragma mark 与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    WTLog(@"与主机连接成功");
    //主机连接成功后,发送密码进行授权
    [self sendPwdToHost];
    
}

#pragma mark 与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    
    //如果有错误,代表连接失败
    WTLog(@"与主机断开连接%@",error);
    
}

#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    WTLog(@"授权成功");
    [self sendOnlineToHost];
}



#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    
    WTLog(@"授权失败%@",error);
    
}


#pragma mark -公共方法
#pragma mark 注销
-(void)logout{
    //1.发送离线消息
    XMPPPresence *offline =[XMPPPresence presenceWithType:@""];
    [_xmppStream sendElement:offline];
    
    //2.与服务器断开连接
    [_xmppStream disconnect];
    
    
}


@end
