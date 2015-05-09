//
//  WTLoginViewController.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/8.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTLoginViewController.h"
#import "WTRegisterViewController.h"
#import "WTNavigationController.h"

@interface WTLoginViewController ()<WTRegisterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
- (IBAction)loginClick:(id)sender;

@end

@implementation WTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置pwdField的锁image
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    
    //设置用户名为上次登录的用户名
    
    //从WTUserInfo获取用户名
    NSString *user=[WTUserInfo sharedWTUserInfo].user;
    self.userLabel.text=user;
}



- (IBAction)loginClick:(id)sender {
    // 登录
    /**
     *  官方的登录实现
     
     1.把用户名和密码放在WTUserInfo的单例
     
     
     
     
     2.调用 AppDelegate的一个connect 连接到服务并登录
     */
    
    
    WTUserInfo *userInfo = [WTUserInfo sharedWTUserInfo];
    userInfo.user=self.userLabel.text;
    userInfo.pwd=self.pwdField.text;
    //调用父类的登录
    [super login];
}

/**
 *  跳转的segue
 *
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //获取注册控制器
    id destVc=segue.destinationViewController;
    if ([destVc isKindOfClass:[WTNavigationController class]]) {
        WTNavigationController *registerNav=destVc;
        //先确定是注册控制器再设置代理,这里可能是其他登录的控制器
        if ([registerNav.topViewController isKindOfClass:[WTRegisterViewController class]]) {
            //获取根控制器
            WTRegisterViewController *registerVc= (WTRegisterViewController*)registerNav.topViewController;
            
                registerVc.delegate=self;
            

        }
        
        
        
    }
    
  
    
    
}

#pragma mark - WTRegisterViewControllerDelegate
-(void)registerViewControllerDidFinishRegister{
    
    WTLog(@"完成注册!");
    self.userLabel.text=[WTUserInfo sharedWTUserInfo].registerUser;
    [MBProgressHUD showSuccess:@"注册完成,请输入密码登录~~" toView:self.view];
    
}

@end
