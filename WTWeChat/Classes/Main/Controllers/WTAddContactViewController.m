//
//  WTAddContactViewController.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/10.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTAddContactViewController.h"

@interface WTAddContactViewController ()<UITextFieldDelegate>

@end

@implementation WTAddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}


#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //添加好友
    
    //1.获取好友账号
    NSString *user =textField.text;
    WTLog(@"%@",user);
    //判断这个账号是否为手机号码
    if (![textField isTelphoneNum]) {
        //提示
        [self showAlert:@"请输入正确的手机号码"];
        return YES;
    }
    
    
    //判断是否添加自己
    if ([user isEqualToString:[WTUserInfo sharedWTUserInfo].user]) {
        [self showAlert:@"不能添加自己为好友"];
        return YES;
    }
    NSString *jidStr=[NSString stringWithFormat:@"%@@%@",user,domain];//注意@"%@@%@"中间之所多一个'@'是因为格式所需
    
    XMPPJID *friendJid=[XMPPJID jidWithString:jidStr];
    
    
    //判断好友是否已经存在
    if([[WTXMPPTool sharedWTXMPPTool].rosterStorage userExistsWithJID:friendJid xmppStream:[WTXMPPTool sharedWTXMPPTool].xmppStream ]){
        [self showAlert:@"当前好友已经存在"];
        return YES;
    }
    
    //2.发送好友添加的请求
    //添加好友,xmpp有个叫订阅

    
    [[WTXMPPTool sharedWTXMPPTool].roster subscribePresenceToUser:friendJid];
    
    return YES;
    
}


-(void)showAlert:(NSString *)msg{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
    
    
}


@end
