//
//  WTInputView.m
//  WTWeChat
//
//  Created by 张威庭 on 15/5/10.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import "WTInputView.h"

@implementation WTInputView

+(instancetype)inputView{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"WTInputView" owner:nil options:nil]lastObject];
    
    
}
@end
