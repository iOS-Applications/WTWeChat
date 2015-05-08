//
//  AppDelegate.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/5.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "WTNavigationController.h"


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
    XMPPResultBlock _resultBlock;
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

    //设置导航栏的背景
    [WTNavigationController setupNavTheme];
    
    //从沙盒加载用户的数据到单例
    [[WTUserInfo sharedWTUserInfo] loadUserInfoFromSanbox];
    
    //是否登录过
    if ([WTUserInfo sharedWTUserInfo].loginStatus) {
        //回到主界面
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        self.window.rootViewController=storyboard.instantiateInitialViewController;
        
        //自动登录服务
        [self xmppUserLogin:nil];
        
    }
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
    
    //从单例WTUserInfo获取用户名
    NSString *user =[WTUserInfo sharedWTUserInfo].user;

    
    
    //resource 标识用户登录的客户端 iPhone Android
    XMPPJID *myJID=[XMPPJID jidWithUser:user domain:@"zhangweiting.local" resource:@"iphone"];
    
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
    //从WTUserInfo里获取密码
    NSString *pwd =[WTUserInfo sharedWTUserInfo].pwd;
    
    [_xmppStream authenticateWithPassword:pwd error:&err];
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
    
    
    //如果没有错误,表示正常的断开连接(人为断开连接)
    
    if (error&&_resultBlock) {
        _resultBlock(XMPPResultTypeNetErr);
    }
    WTLog(@"与主机断开连接%@",error);
    
}

#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    WTLog(@"授权成功");
    [self sendOnlineToHost];
    
    
    //判断block有无值,再回调给登录控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
    
    
}




#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    
    WTLog(@"授权失败%@",error);
    
    //判断block有无值,再回调给登录控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
    
}


#pragma mark -公共方法
#pragma mark 注销
-(void)xmppUserlogout{
    //1.发送离线消息

    XMPPPresence *offline =[XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    //2.与服务器断开连接
    [_xmppStream disconnect];
    
    //3.回到登录界面
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    
    self.window.rootViewController=storyboard.instantiateInitialViewController;
    
    //4.保存注销状态到沙盒
    [WTUserInfo sharedWTUserInfo].loginStatus=NO;
    [[WTUserInfo sharedWTUserInfo ] saveUserInfoToSanbox];
    
    
}
#pragma mark 登录
-(void)xmppUserLogin:(XMPPResultBlock)resultBlock{
    
    //先把block存起来
    _resultBlock=resultBlock;
    
     //  reason Domain=XMPPStreamErrorDomain Code=1 "Attempting to connect while already connected or connecting." UserInfo=0x7fd86bf06700 {NSLocalizedDescription=Attempting to connect while already connected or connecting.}
    //如果以前连接过服务,要断开
    if (_xmppStream.isConnected) {
        [_xmppStream disconnect];
    }
    
    //程序一启动就连接到主机,成功后发送密码
    [self connectToHost];

    
}



@end
