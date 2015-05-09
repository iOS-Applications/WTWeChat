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
#import "DDLog.h"
#import "DDTTYLogger.h"


@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 沙盒的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    WTLog(@"%@",path);
    
    // 打开XMPP的日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    
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
        [[WTXMPPTool sharedWTXMPPTool] xmppUserLogin:nil];
        
    }
    return YES;
}


@end
