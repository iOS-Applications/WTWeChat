//
//  WTRegisterViewController.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/8.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTRegisterViewController.h"
#import "AppDelegate.h"

@interface WTRegisterViewController ()
- (IBAction)registerClick;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
- (IBAction)cancel:(UIBarButtonItem *)sender;

@end

@implementation WTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册";
    //判断当前设备的类型 改变左右两边约束的距离
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone){
        
        self.leftConstraint.constant=10;
        self.rightConstraint.constant=10;
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registerClick {
    
    [self.view endEditing:YES];
    
    
    //0.判断用户输入的是否为手机号码
    if (![self.userField isTelphoneNum]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    
    //1.把用户注册的数据保存到单例
    WTUserInfo *userInfo= [WTUserInfo sharedWTUserInfo];
    userInfo.registerUser=self.userField.text;
    userInfo.registerPwd=self.pwdField.text;
    
    //2.调用WTXMPPTool的xmppUserRegister
//    AppDelegate *app=[UIApplication sharedApplication].delegate;
//    app.registerOperation=YES;
    WTXMPPTool *xmppTool=[WTXMPPTool sharedWTXMPPTool];
    xmppTool.registerOperation=YES;
    //提示
    [MBProgressHUD showMessage:@"正在注册中..." toView:self.view];
    
    __weak typeof (self) selfVC=self;
    
    [xmppTool xmppUserRegister:^(XMPPResultType type) {
        
        
        [selfVC handleResultType:type];
        
    }];
    
   
    
    
}
/**
 *  处理注册的结果
 */
-(void)handleResultType:(XMPPResultType) type{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        switch (type) {
            case XMPPResultTypeRegisterSuccess:
                [MBProgressHUD showSuccess:@"注册成功!" toView:self.view];
                
                if ([self.delegate respondsToSelector:@selector(registerViewControllerDidFinishRegister)]) {
                    [self.delegate registerViewControllerDidFinishRegister];
                }
                
                //回到上个窗口
                [self dismissViewControllerAnimated:YES completion:nil];
                
                break;
            case XMPPResultTypeRegisterFailure:
                [MBProgressHUD showError:@"注册失败,用户名重复" toView:self.view];
                
                break;
            case XMPPResultTypeNetErr:
                
                [MBProgressHUD showError:@"网络不给力~~" toView:self.view];
                break;
                
            default:
                break;
        }

    });
    
    
    
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (IBAction)textChange {
    
    WTLog(@"xxx");
    //设置注册按钮的可点击状态
    BOOL enabled=(self.userField.text.length!=0&&self.pwdField.text.length!=0);
    self.registerBtn.enabled=enabled;
    
    
}




@end
