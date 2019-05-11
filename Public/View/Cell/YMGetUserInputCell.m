//
//  YMGetUserInputCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/11/30.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMGetUserInputCell.h"
#import "UIView+Extension.h"
#import "YMBillDetailKeyValueModel.h"
#import "YMTransferToBankSearchFeeDataModel.h"
#import "YMTransferCheckPayPwdDataModel.h"
#import "YMBankCardModel.h"
#import "YMUserInfoTool.h"
#import "UITextField+Extension.h"

@interface YMGetUserInputCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *leftLabel;
@end

@implementation YMGetUserInputCell

-(UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel               = [[UILabel alloc]init];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.textColor     = [UIColor grayColor];
        _leftLabel.font          = COMMON_FONT;
    }
    
    return _leftLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField * userName = [[UITextField alloc]init];
        userName.placeholder   = @"请输入手机号／邮箱";
        userName.borderStyle   = UITextBorderStyleNone;
        userName.font          = COMMON_FONT;
        userName.leftViewMode  = UITextFieldViewModeAlways;
        [self.contentView addSubview:userName];
        _userInputTF           = userName;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.userInputTF.x      = LEFTSPACE;
    self.userInputTF.y      = 0;
    if (_isSetWidth) {
        self.userInputTF.width  = self.contentView.width - LEFTSPACE ;
    }else{
        self.userInputTF.width  = self.contentView.width - LEFTSPACE * 2;
    }
    self.userInputTF.height = self.contentView.height;
}

-(void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = [leftTitle copy];
    
    //字符串长度为2就手动添加一个空格
    if (_leftTitle.length == 2) {
        NSMutableString *mStr = [[NSMutableString alloc]initWithString:_leftTitle];
        [mStr insertString:@"　" atIndex:1];
        _leftTitle = mStr;
    }
    
    self.leftLabel.text = _leftTitle;
    [self.leftLabel sizeToFit];
    self.leftLabel.size = CGSizeMake(self.leftLabel.size.width + 20, self.leftLabel.size.height);
    _userInputTF.leftView = self.leftLabel;
}

- (void)setKeyOrValueModel:(YMBillDetailKeyValueModel *)keyOrValueModel
{
    _keyOrValueModel = keyOrValueModel;
    if (_keyOrValueModel == nil) {
        return;
    }
    self.leftTitle = [_keyOrValueModel getKeyString];
    
    NSString *valueStr = [_keyOrValueModel getValueString];
    
    self.userInputTF.text = valueStr;
    if (!valueStr.length) {
        self.userInputTF.placeholder = @"";
    }
}
//转账到银行卡 信息确认cell
- (void)sendTransferWithRowNum:(NSInteger)rowNum model:(YMTransferToBankSearchFeeDataModel *)model
{
    self.userInputTF.enabled   = NO;
    self.userInputTF.textColor = FONTDARKCOLOR;
    self.userInputTF.font      = COMMON_FONT;
    
    switch (rowNum) {
        case 0:
        {
            NSString *valueStr = [model getBankAcMsgStr];
            self.leftTitle = @"收款账号";
            self.userInputTF.text = valueStr;
            if ([@"" isEqualToString:valueStr]||valueStr == nil) {
                self.userInputTF.placeholder = @"";
            }
        }
            break;
        case 1:
        {
            NSString *valueStr = [model getCardNameStr];
            self.leftTitle = @"收款人    ";
            self.userInputTF.text = valueStr;
            if ([@"" isEqualToString:valueStr]||valueStr == nil) {
                self.userInputTF.placeholder = @"";
            }
        }
            break;
        default:
            break;
    }
}
//转账到银行卡 处理中。。。 cell
- (void)sendTransferProcessWithRowNum:(NSInteger)rowNum model:(YMTransferCheckPayPwdDataModel *)model
{
    self.userInputTF.enabled   = NO;
    self.userInputTF.textColor = FONTDARKCOLOR;
    self.userInputTF.font      = COMMON_FONT;
    switch (rowNum) {
        case 0:
        {
            NSString *valueStr = [model getBankAcMsgStr];
            self.leftTitle = @"收款账号";
            self.userInputTF.text = valueStr;
            if ([@"" isEqualToString:valueStr]||valueStr == nil) {
                self.userInputTF.placeholder = @"";
            }
        }
            break;
        case 1:
        {
            NSString *valueStr = [model getCardNameStr];
            self.leftTitle = @"收款人    ";
            self.userInputTF.text = valueStr;
            if ([@"" isEqualToString:valueStr]||valueStr == nil) {
                self.userInputTF.placeholder = @"";
            }
        }
            break;
        default:
            break;
    }
}
- (void)setIsSetWidth:(BOOL)isSetWidth
{
    _isSetWidth = isSetWidth;
}

//验证银行卡（储蓄卡、信用卡）app4期修改
- (void)sendBankCardWithSection:(NSInteger)section row:(NSInteger)row model:(YMBankCardModel *)model
{
    self.userInputTF.enabled   = NO;
    self.userInputTF.textColor = FONTCOLOR;
    self.userInputTF.font      = COMMON_FONT;
    self.userInputTF.delegate = self;
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    
    if (model.getCardTypeCount == 1) {//储蓄卡
        switch (row) {
            case 0:
            {
                self.leftTitle = @"发卡行";
                self.userInputTF.text = [model getBankNameAndTypeStr];
            }
                break;
            case 1:
            {
                self.leftTitle = @"卡号";
                self.userInputTF.text = [model getBankAcNoStr];
            }
                break;
            case 2:
            {
                self.leftTitle = @"持卡人";
                self.userInputTF.text = currentInfo.custName;
            }
                break;
            case 3:
            {
                self.leftTitle = @"身份证";
                self.userInputTF.text = [self setSecurityText:currentInfo.custCredNo];
            }
                break;
            default:
                break;
        }
    }else if (model.getCardTypeCount == 2){//信用卡
        if (section == 0) {
            switch (row) {
                case 0:
                {
                    self.leftTitle = @"发卡行";
                    self.userInputTF.text = [model getBankNameAndTypeStr];
                }
                    break;
                case 1:
                {
                    self.leftTitle = @"持卡人";
                    self.userInputTF.text = currentInfo.custName;
                }
                    break;
                default:
                    break;
            }
        }else if (section == 1){
            switch (row) {
                case 0:
                {
                    self.leftTitle = @"身份证";
                    self.userInputTF.text = [self setSecurityText:currentInfo.custCredNo];
                }
                    break;
                case 1:
                {
                    self.leftTitle = @"有效期";
                    self.userInputTF.placeholder = @"信用卡有效期";
                }
                    break;
                case 2:
                {
                    self.userInputTF.enabled   = YES;
                    self.leftTitle = @"安全码";
                    self.userInputTF.placeholder = @"请输入信用卡背后面三位数字";
                    self.userInputTF.keyboardType = UIKeyboardTypeNumberPad;
                    self.userInputTF.tag = 200;
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    if (section == 2) {
        switch (row) {
            case 0:
            {
                self.userInputTF.enabled = YES;
                self.leftTitle = @"手机号";
                self.userInputTF.placeholder = @"请输入银行预留手机号";
                self.userInputTF.text = @"";
                self.userInputTF.keyboardType = UIKeyboardTypeNumberPad;
                self.userInputTF.tag = 201;
            }
                break;
            default:
                break;
        }
    }
}
-(NSString *)setSecurityText:(NSString *)str
{
    NSString *str1 = [str substringToIndex:4];
    NSString *str2 = [str substringFromIndex:14];
    return [[str1 stringByAppendingString:@"********"]stringByAppendingString:str2];
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
    if (textField.tag == 201) {
        return [UITextField textFieldWithPhoneFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}
- (void)textFieldEditChanged:(UITextField *)textField
{
    YMLog(@"textField = %@",textField.text);
    if (textField.tag == 200) {
        if (textField.text.length>3) {
            textField.text = [textField.text substringToIndex:3];
            return;
        }
        if ([self.delegate respondsToSelector:@selector(textFieldWithAnQuanMa:)]) {
            [self.delegate textFieldWithAnQuanMa:textField.text];
        }
    }else if(textField.tag == 201){
        if ([self.delegate respondsToSelector:@selector(textFieldWithPhone:)]) {
            [self.delegate textFieldWithPhone:textField.text];
        }
    }
}

@end
