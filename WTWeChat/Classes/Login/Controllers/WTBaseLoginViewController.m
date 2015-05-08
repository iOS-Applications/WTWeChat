//
//  WTBaseLoginViewController.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/8.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTBaseLoginViewController.h"
#import "AppDelegate.h"

@interface WTBaseLoginViewController ()

@end

@implementation WTBaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}








-(void)login{
  
    //隐藏键盘
    [self.view endEditing:YES];
    
    //登录之前给个提示
    
    [MBProgressHUD showMessage:@"正在登录中~" toView:self.view];
    
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    
    __weak typeof (self)selfVc=self;
    
    [app xmppUserLogin:^(XMPPResultType type) {
        
        [selfVc handleResultType:type];
        
    }];
    
}


-(void)handleResultType:(XMPPResultType)type{
    //主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        //在view中隐藏
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        switch (type) {
            case XMPPResultTypeLoginSuccess:
            {
                [WTUserInfo sharedWTUserInfo].loginStatus=YES;
                //把用户登录成功的数据,保存到沙盒
                [[WTUserInfo sharedWTUserInfo] saveUserInfoToSanbox];
                
                //隐藏模态窗口才能销毁控制器,才不会内存泄露
                [self dismissViewControllerAnimated:YES completion:nil];
                
                WTLog(@"success");
                // 登录成功来到主界面
                // 此方法是在子线程里调用,所以要在主线程刷新UI
                
                UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                
                self.view.window.rootViewController=storyboard.instantiateInitialViewController;
                
                
            }
                break;
                
            case XMPPResultTypeLoginFailure:
                [WTUserInfo sharedWTUserInfo].loginStatus=NO;
                //把用户登录失败的数据,保存到沙盒
                [[WTUserInfo sharedWTUserInfo] saveUserInfoToSanbox];
                
                WTLog(@"failure");
                [MBProgressHUD showError:@"用户名或者密码不正确!" toView:self.view];
                break;
                
            case XMPPResultTypeNetErr:
                [WTUserInfo sharedWTUserInfo].loginStatus=NO;
                //把用户登录失败的数据,保存到沙盒
                [[WTUserInfo sharedWTUserInfo] saveUserInfoToSanbox];
                
                [MBProgressHUD showError:@"网络不给力!"toView:self.view];
                
                break;
            default:
                break;
        }
        
    });
    
    
}




@end
