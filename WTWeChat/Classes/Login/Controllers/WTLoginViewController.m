//
//  WTLoginViewController.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/8.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTLoginViewController.h"

@interface WTLoginViewController ()
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

    
    
    [super login];
}
@end
