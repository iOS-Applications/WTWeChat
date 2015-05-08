//
//  UIButton+WF.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/8.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "UIButton+WF.h"

@implementation UIButton (WF)

-(void)setN_BG:(NSString *)nbg H_BG:(NSString *)hbg{
    [self setBackgroundImage:[UIImage imageNamed:nbg] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:hbg] forState:UIControlStateHighlighted];
}


-(void)setResizeN_BG:(NSString *)nbg H_BG:(NSString *)hbg{
    [self setBackgroundImage:[UIImage stretchedImageWithName:nbg] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage stretchedImageWithName:hbg] forState:UIControlStateHighlighted];
}
@end
