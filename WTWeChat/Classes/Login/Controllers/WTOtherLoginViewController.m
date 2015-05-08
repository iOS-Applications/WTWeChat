//
//  WTOtherLoginViewController.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/7.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTOtherLoginViewController.h"
#import "AppDelegate.h"

@interface WTOtherLoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
- (IBAction)loginClick;
- (IBAction)cancel:(UIBarButtonItem *)sender;

@end

@implementation WTOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //判断当前设备的类型 改变左右两边约束的距离
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone){
        
        self.leftConstraint.constant=10;
        self.rightConstraint.constant=10;
        
    }
    
    

}


- (IBAction)loginClick {
    // 登录
    /**
     *  官方的登录实现
     
     1.把用户名和密码放在WTUserInfo的单例
     
     
     
     
     2.调用 AppDelegate的一个connect 连接到服务并登录
     */

    
    WTUserInfo *userInfo = [WTUserInfo sharedWTUserInfo];
    userInfo.user=self.userField.text;
    userInfo.pwd=self.pwdField.text;
    
    [super login];
   
}






-(void)dealloc{
    
    WTLog(@"");
}



- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
