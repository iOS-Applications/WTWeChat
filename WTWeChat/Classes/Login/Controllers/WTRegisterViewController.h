//
//  WTRegisterViewController.h
//  WTWeChat
//
//  Created by 张威庭 on 15/5/8.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTRegisterViewControllerDelegate <NSObject>

@optional
/**
 *  完成注册
 */
-(void)registerViewControllerDidFinishRegister;

@end

@interface WTRegisterViewController : UIViewController


@property (nonatomic,weak) id<WTRegisterViewControllerDelegate> delegate;
@end
