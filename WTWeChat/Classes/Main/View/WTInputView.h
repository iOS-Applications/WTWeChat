//
//  WTInputView.h
//  WTWeChat
//
//  Created by 张威庭 on 15/5/10.
//  Copyright (c) 2015年 张威庭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTInputView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
+(instancetype)inputView;
   

@end
