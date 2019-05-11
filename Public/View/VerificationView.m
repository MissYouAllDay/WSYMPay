//
//  VerificationView.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/18.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "VerificationView.h"

@interface VerificationView ()<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *verificationTextField;
@property (nonatomic, weak) UIButton *countdownButton;
@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, assign) NSInteger countdown;

@property (nonatomic, weak) NSTimer *timer;
@end

@implementation VerificationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews
{
    //验证码
    UITextField *verificationTextField = [[UITextField alloc]init];
    verificationTextField.borderStyle  = UITextBorderStyleNone;
    verificationTextField.placeholder  = @"请输入验证码";
    verificationTextField.font         = COMMON_FONT;
    verificationTextField.keyboardType = UIKeyboardTypeNumberPad;
    verificationTextField.delegate     = self;
//    [verificationTextField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:verificationTextField];
   
    self.verificationTextField = verificationTextField;
    
    //倒计时
    UIButton *countdownButton                   = [[UIButton alloc]init];
 
    countdownButton.titleLabel.font             = [UIFont systemFontOfSize:COMMON_FONT.pointSize - 1.0f];
    countdownButton.adjustsImageWhenHighlighted = NO;
    [countdownButton setTitle:@"发送短信" forState:UIControlStateNormal];
    [countdownButton setTitle:@"s后重发" forState:UIControlStateDisabled];
    [countdownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [countdownButton setTitleColor:RGBColor(222, 81, 78) forState:UIControlStateNormal];
    [countdownButton setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"code_selected"] forState:UIControlStateNormal];
    [countdownButton setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"code"]forState:UIControlStateDisabled];
    [countdownButton addTarget:self action:@selector(countdownButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:countdownButton];
    self.countdownButton = countdownButton;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [self.verificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width).multipliedBy(.65);
        
    }];
    
    [self.countdownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(0);
        make.centerY.equalTo(self.verificationTextField.mas_centerY);
        make.height.equalTo(self.mas_height).multipliedBy(.7);
        make.width.equalTo(self.mas_width).multipliedBy(.3);
        
        
    }];
    
}
//倒计时按钮被点击
-(void)countdownButtonClick
{
    if ([self.delegate respondsToSelector:@selector(verificationViewCountdownButtonDidClick:)]) {
        
        [self.delegate verificationViewCountdownButtonDidClick:self];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.verificationTextField == textField) {
        if (textField.text.length >= 6) {
            textField.text = [textField.text substringToIndex:5];
        }
        self.verificationCode      = textField.text;
        if ([self.delegate respondsToSelector:@selector(verificationViewTextDidEditingChange:)]) {
            [self.delegate verificationViewTextDidEditingChange:textField.text];
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.verificationCode      = textField.text;
    if ([self.delegate respondsToSelector:@selector(verificationViewTextDidEditingChange:)]) {
        [self.delegate verificationViewTextDidEditingChange:textField.text];
    }

}


//-(void)textFieldTextDidChange:(UITextField *)textField
//{
//
//    if (self.verificationTextField == textField) {
//        if (textField.text.length >= 6) {
//            textField.text = [textField.text substringToIndex:6];
//        }
//        self.verificationCode      = textField.text;
//        if ([self.delegate respondsToSelector:@selector(verificationViewTextDidEditingChange:)]) {
//            [self.delegate verificationViewTextDidEditingChange:textField.text];
//        }
//    }
//}

-(void)setVerificationCode:(NSString *)verificationCode
{
    _verificationCode = [verificationCode copy];
    self.verificationTextField.text = _verificationCode;
}


-(void)createTimer
{
    self.countdown = 60;
    self.countdownButton.enabled = NO;
    [self.timer invalidate];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startCountdown) userInfo:nil repeats:YES];
    [timer fire];
    self.timer     = timer;
    _isCountDown = YES;
}

-(void)startCountdown
{
    self.countdown--;
    
    NSString *title = [NSString stringWithFormat:@"%lus后重发",(unsigned long)self.countdown];
    [self.countdownButton setTitle:title forState:UIControlStateDisabled];
    
    if (self.countdown == 0) {
        [self.timer invalidate];
        _isCountDown = NO;
        self.countdownButton.enabled = YES;
    }
}

-(void)setShowLeftTitlt:(BOOL)showLeftTitlt
{
    _showLeftTitlt = showLeftTitlt;
    
    if (_showLeftTitlt) {
        
        UILabel* code      = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 45)];
        code.textAlignment = NSTextAlignmentLeft;
        code.text          = @"验证码";
        code.textColor     = [UIColor grayColor];
        code.font          = COMMON_FONT;
        self.verificationTextField.leftViewMode = UITextFieldViewModeAlways;
        self.verificationTextField.leftView     = code;
        [self.countdownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

-(void)timerInvalidate
{
    self.countdown = 0;
    [self.timer invalidate];
    _isCountDown = NO;
    self.countdownButton.enabled = YES;
}


-(void)setCountdownButtonTitle:(NSString *)countdownButtonTitle
{
    _countdownButtonTitle = [countdownButtonTitle copy];
    
    [self.countdownButton setTitle:_countdownButtonTitle forState:UIControlStateNormal];
}

@end
