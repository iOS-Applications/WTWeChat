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
//    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    
    //设置导航栏的背景
    [WTNavigationController setupNavTheme];
    
    //从沙盒加载用户的数据到单例
    [[WTUserInfo sharedWTUserInfo] loadUserInfoFromSanbox];
    
    // 判断用户的登录状态，YES 直接来到主界面
    if ([WTUserInfo sharedWTUserInfo].loginStatus) {
        //回到主界面
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        self.window.rootViewController=storyboard.instantiateInitialViewController;
        
        // 自动登录服务
        // 1秒后再自动登录
#warning 一般情况下，都不会马上连接，会稍微等等
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[WTXMPPTool sharedWTXMPPTool] xmppUserLogin:nil];
        });
    }
    
    
    //注册应用接收通知
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }

    return YES;
}


@end
