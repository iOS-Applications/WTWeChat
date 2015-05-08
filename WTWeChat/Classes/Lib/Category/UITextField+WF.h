//
//  UITextField+WF.h
//  WTWeChat
//
//  Created by 张威庭 on 15/5/8.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (WF)

/**
 添加文件输入框左边的View,添加图片
 */
-(void)addLeftViewWithImage:(NSString *)image;

/**
 * 判断是否为手机号码
 */
-(BOOL)isTelphoneNum;
@end
