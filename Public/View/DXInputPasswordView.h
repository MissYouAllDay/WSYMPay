//
//  DXInputPasswordView.h
//  test-A
//
//  Created by TY on 16/9/1.
//  Copyright © 2016年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXInputPasswordView;

@protocol DXInputPasswordViewDelegate <NSObject>

@optional

//输入达到上限时调用此方法并返回输入的数字
-(void)inputPasswordView:(DXInputPasswordView *)inputPasswordView completeInput:(NSString *)str;

@end


@interface DXInputPasswordView : UIView

@property (nonatomic, weak) id <DXInputPasswordViewDelegate> delegate;

//默认是15
@property (nonatomic, assign) CGFloat dotSize;

//边框颜色 默认是灰色
@property (nonatomic, strong) UIColor *borderColor;

//分隔线颜色 默认是灰色
@property (nonatomic, strong) UIColor *intervalLineColor;

//底部的UITextField
@property (nonatomic, strong) UITextField *textField;

//清空输入框
-(void)clearUpPassword;

-(void)becomeFirstResponder;
@end
