//
//  WTHistoryViewController.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/11.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTHistoryViewController.h"

@interface WTHistoryViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIView *loadView;

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
                [self.indicatorView startAnimating];
                break;
            case XMPPResultTypeNetErr://连接失败
                [self.indicatorView stopAnimating];
                self.loadView.hidden=YES;
                [MBProgressHUD showError:@"连接失败" toView:self.view];
                break;
            case XMPPResultTypeLoginSuccess://登录成功也就是连接成功
                [self.indicatorView stopAnimating];
                [MBProgressHUD showSuccess:@"连接成功" toView:self.view];
                self.loadView.hidden=YES;
                break;
            case XMPPResultTypeLoginFailure://登录失败
                [self.indicatorView stopAnimating];
                [MBProgressHUD showError:@"登录失败" toView:self.view];
                self.loadView.hidden=YES;
                break;
            default:
                break;
        }
    });
    
}


@end
