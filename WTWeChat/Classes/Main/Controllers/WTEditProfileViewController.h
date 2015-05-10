//
//  WTEditProfileViewController.h
//  WTWeChat
//
//  Created by 张威庭 on 15/5/9.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol WTEditProfileViewControllerDelegate <NSObject>

@optional
-(void)editProfileViewControllerDelegateDidSave;

@end

@interface WTEditProfileViewController : UITableViewController


@property (nonatomic,strong) UITableViewCell *cell;

@property (nonatomic,weak) id<WTEditProfileViewControllerDelegate> delegate;

@end
