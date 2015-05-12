//
//  WTProfileViewController.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/9.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "WTEditProfileViewController.h"

@interface WTProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WTEditProfileViewControllerDelegate>
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headView;
/**
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
/**
 *  微信号
 */
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;
/**
 *  公司名称
 */
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;
/**
 *  部门名称
 */
@property (weak, nonatomic) IBOutlet UILabel *orgunitLabel;
/**
 *  职位
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  电话
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/**
 *  邮箱
 */
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation WTProfileViewController
/**
 *  加载名片信息
 */
- (void)loadVCard {
    //显示个人信息
    XMPPvCardTemp *myVCard=[WTXMPPTool sharedWTXMPPTool].vCard.myvCardTemp;
    
    //设置头像
    if (myVCard.photo) {
        self.headView.image=[UIImage imageWithData:myVCard.photo];
    }
    
    //设置昵称
    self.nickNameLabel.text=myVCard.nickname;
    
    //设置微信号(用户名)
    self.weixinNumLabel.text=[WTUserInfo sharedWTUserInfo].user;
    
    //公司
    self.orgNameLabel.text=myVCard.orgName;
    //部门
    if (myVCard.orgUnits.count>0) {
        self.orgunitLabel.text=myVCard.orgUnits[0];
    }
    //职位
    self.titleLabel.text=myVCard.title;
    
    //电话
#warning myVCard.telecomsAddresses 这个get方法,没有对电子名片的XML数据进行解析
    //    self.phoneLabel.text=myVCard.telecomsAddresses;
    //使用note字段充当电话
    self.phoneLabel.text=myVCard.note;
    
    //邮箱
    //    self.emailLabel.text=myVCard.emailAddresses;
    //用mailer充当邮箱
//    self.emailLabel.text=myVCard.mailer;
    
    //邮箱解析
    if (myVCard.emailAddresses.count > 0) {
        //不管有多少个邮件，只取第一个
        self.emailLabel.text = myVCard.emailAddresses[0];
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人信息";
    [self loadVCard];
}


#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取cell.tag
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger tag=cell.tag;
    //判断
    if (tag==2) {//不做任何操作
        WTLog(@"不做任何操作");
        return;
    }
    
    if (tag==0) {//选择照片
        WTLog(@"选择照片");
        UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相册", nil];
        [sheet showInView:self.view];
    }
    if (tag==1) {//跳到下一个控制器
        WTLog(@"跳到下一个控制器");

        [self performSegueWithIdentifier:@"EditVCardSegue" sender:cell];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //获取编辑个人信息的控制器
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[WTEditProfileViewController class]]) {
        WTEditProfileViewController *editVc=destVc;
        editVc.cell=sender;
        editVc.delegate=self;
    }
    
}


#pragma mark -UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==2) {//取消
        return;
    }
    
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    
    //设置代理
    imagePicker.delegate=self;
    
    //设置允许编辑
    imagePicker.allowsEditing=YES;
    if (buttonIndex==0) {//相机
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    }else{//相册
        
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //显示图片选择器
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark -UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    WTLog(@"%@",info);
    
    //获取图片 设置图片
    
    UIImage *image=info[UIImagePickerControllerEditedImage];
    self.headView.image=image;
    //隐藏当前模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    //更新到服务器
    [self editProfileViewControllerDelegateDidSave];
    
    
}


#pragma mark -WTEditProfileViewControllerDelegate
-(void)editProfileViewControllerDelegateDidSave{
    //更新到服务器
    
    //获取当前的电子名片信息
    XMPPvCardTemp *myvCard = [WTXMPPTool sharedWTXMPPTool].vCard.myvCardTemp;
    
    // 图片
    myvCard.photo = UIImagePNGRepresentation(self.headView.image);
    
    // 昵称
    myvCard.nickname = self.nickNameLabel.text;
    
    // 公司
    myvCard.orgName = self.orgNameLabel.text;
    
    // 部门
    if (self.orgunitLabel.text.length > 0) {
        myvCard.orgUnits = @[self.orgunitLabel.text];
    }
    
    
    // 职位
    myvCard.title = self.titleLabel.text;
    
    
    // 电话
    myvCard.note =  self.phoneLabel.text;
    
    // 邮件
    //myvCard.mailer = self.emailLabel.text;
    if (self.emailLabel.text.length > 0) {
        myvCard.emailAddresses = @[self.emailLabel.text];
        WTLog(@"%@",@[self.emailLabel.text]);
    }

    
    
    //更新 这个方法内部会实现数据上传到服务，无需程序自己操作
    [[WTXMPPTool sharedWTXMPPTool].vCard updateMyvCardTemp:myvCard];

    
    
    
}




@end
