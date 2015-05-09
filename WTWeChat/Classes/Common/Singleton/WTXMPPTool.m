//
//  WTXMPPTool.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/9.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTXMPPTool.h"


/**
 *  在AppDelegate实现登录
 1.初始化XMPPStream
 2.连接到服务器(传一个JID)
 3.连接到服务成功后,再发送密码授权
 4.授权成功后,发送"在线"消息
 */
@interface WTXMPPTool ()
{
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
    
    /**
     *  电子名片的数据存储
     */
    XMPPvCardCoreDataStorage *_vCardStorage;
    /**
     *  头像模块
     */
    XMPPvCardAvatarModule *_avatar;

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


@implementation WTXMPPTool



singleton_implementation(WTXMPPTool)


#pragma mark -私有方法
#pragma mark 初始化XMPPSteam
-(void)setupXMPPStream{
    _xmppStream = [[XMPPStream alloc] init];
    
    
#warning 每一个模块添加后都要激活
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    
    //激活
    [_vCard activate:_xmppStream];
    
    //添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    //激活
    [_avatar activate:_xmppStream];

    
    
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
    NSString *user=nil;
    if(self.registerOperation){
        user=[WTUserInfo sharedWTUserInfo].registerUser;
    }else {
        
        user =[WTUserInfo sharedWTUserInfo].user;
    }
    
    
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
    
    if(self.registerOperation){//注册操作,发送注册密码
        NSString  *pwd=[WTUserInfo sharedWTUserInfo].registerPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    }else {
        //主机连接成功后,发送密码进行授权
        [self sendPwdToHost];
    }
    
    
    
    
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

#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    WTLog(@"注册成功");
    
    if(_resultBlock){
        
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
    
}

#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    
    /**
     *   注册失败 <iq xmlns="jabber:client" type="error" to="zhangweiting.local/30c71ae5"><query xmlns="jabber:iq:register"><username>13534193189</username><password>123456</password></query><error code="409" type="cancel"><conflict xmlns="urn:ietf:params:xml:ns:xmpp-stanzas"></conflict></error></iq>
     
     */
    
    WTLog(@"注册失败 %@",error);
    if(_resultBlock){
        
        _resultBlock(XMPPResultTypeRegisterFailure);
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
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    
//    self.window.rootViewController=storyboard.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"Login"];
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
    
    //连接到主机,成功后发送登录密码
    [self connectToHost];
    
    
}

#pragma mark 注册
-(void)xmppUserRegister:(XMPPResultBlock)resultBlock{
    //先把block存起来
    _resultBlock=resultBlock;
    
    //  reason Domain=XMPPStreamErrorDomain Code=1 "Attempting to connect while already connected or connecting." UserInfo=0x7fd86bf06700 {NSLocalizedDescription=Attempting to connect while already connected or connecting.}
    //如果以前连接过服务,要断开
    if (_xmppStream.isConnected) {
        [_xmppStream disconnect];
    }
    
    //连接到主机,成功后发送注册密码
    [self connectToHost];
    
    
    
}








@end
