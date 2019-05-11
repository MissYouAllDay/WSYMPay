//
//  YMTransferToBankCardBeiZhuCell.m
//  WSYMPay
//
//  Created by pzj on 2017/5/3.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToBankCardBeiZhuCell.h"

@interface YMTransferToBankCardBeiZhuCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *beiZhuTextField;
@property (nonatomic, strong) UILabel *beiZhuLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation YMTransferToBankCardBeiZhuCell
- (void)textFieldWithBeiZhu:(NSString *)beiZhu{}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - privateMethods               - Method -
- (void)initViews
{
    [self.contentView addSubview:[self beiZhuTextField]];
    [self.contentView addSubview:[self beiZhuLabel]];
    [self.contentView addSubview:[self lineView]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.beiZhuTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
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
   
    [[self lineView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.height-0.5);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - objective-cDelegate          - Method -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    if (range.location>=20) {
        return NO;
    }
    return YES;
}
- (void)textFieldEditChanged:(UITextField *)textField
{
    YMLog(@"textField = %@",textField.text);
    if (textField.text.length>0) {
        [self beiZhuLabel].text = @"";
    }else{
        [self beiZhuLabel].text = @"添加备注(20字以内)";
    }
    if ([self.delegate respondsToSelector:@selector(textFieldWithBeiZhu:)]) {
        [self.delegate textFieldWithBeiZhu:textField.text];
    }
}

#pragma mark - getters and setters          - Method -
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
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = lINECOLOR;
    }
    return _lineView;
}

@end
