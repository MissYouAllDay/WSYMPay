//
//  YMTXSelectBankCardMoneyCell.m
//  WSYMPay
//
//  Created by pzj on 2017/7/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTXSelectBankCardMoneyCell.h"
#import "UITextField+Extension.h"

@interface YMTXSelectBankCardMoneyCell ()<UITextFieldDelegate>

@end

@implementation YMTXSelectBankCardMoneyCell
- (void)textFieldWithMoney:(NSString *)money{}

- (void)setMoneyStr:(NSString *)moneyStr
{
    _moneyStr = moneyStr;
    self.moneyTextField.text = _moneyStr;
}
#pragma mark - objective-cDelegate          - Method -
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    return [UITextField textFieldWithMoneyFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    return YES;
}
- (void)textFieldEditChanged:(UITextField *)textField
{
    YMLog(@"textField = %@",textField.text);
    if ([self.delegate respondsToSelector:@selector(textFieldWithMoney:)]) {
        [self.delegate textFieldWithMoney:textField.text];
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text = @"";
    YMLog(@"textField = %@",textField.text);
    if ([self.delegate respondsToSelector:@selector(textFieldWithMoney:)]) {
        [self.delegate textFieldWithMoney:textField.text];
    }
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.moneyTextField.delegate = self;
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.moneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
