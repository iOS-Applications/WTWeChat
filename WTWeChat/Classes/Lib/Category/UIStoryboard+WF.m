//
//  UIStoryboard+WF.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/8.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "UIStoryboard+WF.h"

@implementation UIStoryboard (WF)

+(void)showInitialVCWithName:(NSString *)name{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    //WXLog(@"%@",[UIApplication sharedApplication].keyWindow);
    [UIApplication sharedApplication].keyWindow.rootViewController = storyboard.instantiateInitialViewController;
}

+(id)initialVCWithName:(NSString *)name{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    return [storyboard instantiateInitialViewController];
}
@end
