//
//  YMTransferMoneyCell.m
//  WSYMPay
//
//  Created by pzj on 2017/5/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferMoneyCell.h"
#import "UITextField+Extension.h"

@interface YMTransferMoneyCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;//转账金额
@property (nonatomic, strong) UILabel *yuanLabel;//¥

@property (nonatomic, strong) UIView *specLine;
@property (nonatomic, strong) UITextField *beiZhuTextField;//备注信息
@property (nonatomic, strong) UILabel *beiZhuLabel;//备注信息 placeholder

@end
@implementation YMTransferMoneyCell
- (void)textFieldBeginEditing{}
- (void)textFieldWithMoney:(NSString *)money{}
- (void)textFieldWithBeiZhu:(NSString *)beiZhu{}
#pragma mark - lifeCycle                    - Method -
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}
#pragma mark - privateMethods               - Method -
- (void)initViews
{
    [self.contentView addSubview:[self titleLabel]];
    [self.contentView addSubview:[self yuanLabel]];
    [self.contentView addSubview:[self moneyTextField]];
    [self.contentView addSubview:[self specLine]];
    [self.contentView addSubview:[self beiZhuTextField]];
    [self.contentView addSubview:[self beiZhuLabel]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(LEFTSPACE);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [self.yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(LEFTSPACE);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(15);
    }];

    [self.moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.yuanLabel.mas_right).offset(5);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(-RIGHTSPACE);
    }];
    
    [self.specLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.yuanLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.beiZhuTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.specLine.mas_bottom).offset(0);
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-RIGHTSPACE);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.beiZhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.beiZhuTextField.mas_top);
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-RIGHTSPACE);
        make.bottom.mas_equalTo(0);
    }];
}
#pragma mark - objective-cDelegate          - Method -
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldBeginEditing)]) {
        [self.delegate textFieldBeginEditing];
    }
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
        if (range.location>=20) {
            return NO;
        }
    }else if (textField.tag == 200){
        return [UITextField textFieldWithMoneyFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}
- (void)textFieldEditChanged:(UITextField *)textField
{
    YMLog(@"textField = %@",textField.text);
    if (textField.tag == 200) {
        if ([self.delegate respondsToSelector:@selector(textFieldWithMoney:)]) {
            [self.delegate textFieldWithMoney:textField.text];
        }
    }else{
        if (textField.text.length>0) {
            [self beiZhuLabel].text = @"";
        }else{
            [self beiZhuLabel].text = @"添加备注(20字以内)";
        }
        if ([self.delegate respondsToSelector:@selector(textFieldWithBeiZhu:)]) {
            [self.delegate textFieldWithBeiZhu:textField.text];
        }
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField.tag == 200) {
        YMLog(@"%@",textField.text);
        textField.text = @"";
        if ([self.delegate respondsToSelector:@selector(textFieldWithMoney:)]) {
            [self.delegate textFieldWithMoney:textField.text];
        }
    }
    return YES;
}
#pragma mark - getters and setters          - Method -
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfMutableSize:12];
        _titleLabel.textColor = FONTCOLOR;
        _titleLabel.text = @"转账金额";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UILabel *)yuanLabel
{
    if (!_yuanLabel) {
        _yuanLabel = [[UILabel alloc] init];
        _yuanLabel.textColor = FONTDARKCOLOR;
        _yuanLabel.font = [UIFont systemFontOfMutableSize:20];
        _yuanLabel.text = @"¥";
    }
    return _yuanLabel;
}

- (UITextField *)moneyTextField
{
    if (!_moneyTextField) {
        _moneyTextField = [[UITextField alloc] init];
        _moneyTextField.font = [UIFont systemFontOfMutableSize:20];
        _moneyTextField.delegate = self;
        _moneyTextField.tag = 200;
        _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _moneyTextField;
}
- (UIView *)specLine
{
    if (!_specLine) {
        _specLine = [[UIView alloc] init];
        _specLine.backgroundColor = LAYERCOLOR;
    }
    return _specLine;
}

- (UITextField *)beiZhuTextField
{
    if (!_beiZhuTextField) {
        _beiZhuTextField = [[UITextField alloc] init];
        _beiZhuTextField.delegate = self;
        _beiZhuTextField.tag = 201;
        _beiZhuTextField.keyboardType = UIKeyboardTypeDefault;
        _beiZhuTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _beiZhuTextField;
}
- (UILabel *)beiZhuLabel
{
    if (!_beiZhuLabel) {
        _beiZhuLabel = [[UILabel alloc] init];
        _beiZhuLabel.text = @"添加备注(20字以内)";
        _beiZhuLabel.textColor = FONTCOLOR;
        _beiZhuLabel.font = [UIFont systemFontOfMutableSize:12];
    }
    return _beiZhuLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
