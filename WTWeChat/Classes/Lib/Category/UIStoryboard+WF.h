//
//  UIStoryboard+WF.h
//  WTWeChat
//
//  Created by 张威庭 on 15/5/8.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (WF)

/**
 * 1.显示Storybaord的第一个控制器到窗口
 */
+(void)showInitialVCWithName:(NSString *)name;
+(id)initialVCWithName:(NSString *)name;
@end
