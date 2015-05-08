//
//  WTNavigationController.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/7.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTNavigationController.h"

@interface WTNavigationController ()

@end

@implementation WTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



+(void)initialize{
    
    
}

+(void)setupNavTheme{
    //设置导航样式
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //1.设置导航条的背景
    
    //高度不会拉伸,但是宽度会拉伸
    [navBar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    
    //2.设置栏的字体
    NSMutableDictionary *att=[NSMutableDictionary dictionary];
    att[NSForegroundColorAttributeName ]=[UIColor whiteColor];
    att[NSFontAttributeName]=[UIFont systemFontOfSize:20];
    [navBar setTitleTextAttributes:att];
    
    
    //设置状态栏的样式
    //Xcode5以上,创建的项目,默认的话,这个状态栏的样式由控制器决定
    //注意只要在Info.plist里添加一个key:View controller-based status bar appearance var:NO就不会让控制器决定了
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
}
////结论,如果控制器是由导航控制器管理,设置状态栏的样式时,要在导航控制器里设置
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    
//    return UIStatusBarStyleLightContent;
//}


@end
