//
//  WTMeViewController.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/8.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTMeViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"

@interface WTMeViewController ()
- (IBAction)logout:(UIBarButtonItem *)sender;
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
/**
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
/**
 *  微信号
 */
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;

@end

@implementation WTMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //显示当前用户个人信息
    /**
     * 如何使用CoreData获取数据
     1.上下文(关联到数据)
     2.FetchRequest请求对象
     3.设置过滤和排序
     4.执行请求获取数据
     *
     */
    
    //XMPP提供了一个方法,直接获取个人信息
    XMPPvCardTemp *myVCard=[WTXMPPTool sharedWTXMPPTool].vCard.myvCardTemp;
    
    //设置头像
    if (myVCard.photo) {
        self.headerView.image=[UIImage imageWithData:myVCard.photo];
    }
    
    //设置昵称
    self.nickNameLabel.text=myVCard.nickname;
    
    //设置微信号(用户名)
    NSString *user=[WTUserInfo sharedWTUserInfo].user;
    self.weixinNumLabel.text=[NSString stringWithFormat:@"微信号:%@",user];
    
    
    
}



- (IBAction)logout:(UIBarButtonItem *)sender {
    
    
    
    [[WTXMPPTool sharedWTXMPPTool] xmppUserlogout];
    
    
}
@end
