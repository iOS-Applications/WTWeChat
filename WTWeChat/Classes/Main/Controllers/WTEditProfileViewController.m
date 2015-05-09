//
//  WTEditProfileViewController.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/9.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTEditProfileViewController.h"

@interface WTEditProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WTEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题和TextField的默认值
    
    self.title=self.cell.textLabel.text;
    
    self.textField.text=self.cell.detailTextLabel.text;
    
    
    //右边添加个item按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
}

-(void)saveBtnClick{
    
    //1.更改cell的detailTextLabel的text
    self.cell.detailTextLabel.text=self.textField.text;
    
   
    [self.cell layoutSubviews];

    
    //2.当前的控制器消失
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
    
}

@end
