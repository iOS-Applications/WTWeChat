//
//  WTHistoryViewController.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/11.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTHistoryViewController.h"

@interface WTHistoryViewController ()

//注意:loadview是不能名这个名字的,会覆盖原来系统自带的属性
//@property (weak, nonatomic) IBOutlet UIView *loadView;


@end

@implementation WTHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 监听一个登录状态的通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xxx:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange:) name:WTLoginStatusChangeNotification object:nil];
}

-(void)loginStatusChange:(NSNotification *)noti{
    
    //通知是在子线程被调用，刷新UI在主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        WTLog(@"%@",noti.userInfo);
        // 获取登录状态
        int status = [noti.userInfo[@"loginStatus"] intValue];
        
        switch (status) {
            case XMPPResultTypeConnecting://正在连接
                
                [MBProgressHUD showMessage:@"正在自动登录中~请稍等!" toView:self.view];
                break;
            case XMPPResultTypeNetErr://连接失败
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:@"连接失败" toView:self.view];
                break;
            case XMPPResultTypeLoginSuccess://登录成功也就是连接成功
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showSuccess:@"连接成功" toView:self.view];
                
                break;
            case XMPPResultTypeLoginFailure://登录失败
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:@"登录失败" toView:self.view];
                
                break;
            default:
                break;
        }
    });
    
}










@end
