//
//  YMMobileCollectionViewCell_phone.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/24.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMMobileCollectionViewCell_phone.h"
#import "UITextField+Extension.h"

@interface YMMobileCollectionViewCell_phone()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField * mobileTextField;
@property (nonatomic, strong) UIButton * contactButton;
@property (nonatomic, strong) UILabel * detailL;
@property (nonatomic, strong) UIImageView * bottomLineImg;
@end

@implementation YMMobileCollectionViewCell_phone
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        
        [self.contentView addSubview:self.mobileTextField];
        
        [self.contentView addSubview:self.contactButton];
        
        [self.contentView addSubview:self.detailL];
        
        [self.contentView addSubview:self.bottomLineImg];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
        [self.contentView addGestureRecognizer:tap];
        
    }
    return self;
}
-(UITextField *)mobileTextField
{
    if (!_mobileTextField) {
        _mobileTextField = [UITextField new];
        
        NSString *holderText = @"请输入手机号！";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfMutableSize:13]
                            range:NSMakeRange(0, holderText.length)];
        
        _mobileTextField.attributedPlaceholder = placeholder;

        _mobileTextField.keyboardType = UIKeyboardTypePhonePad;
        _mobileTextField.returnKeyType = UIReturnKeyDone;
        _mobileTextField.font = [UIFont systemFontOfMutableSize:18];
        _mobileTextField.delegate = self;
        _mobileTextField.backgroundColor = [UIColor whiteColor];
        _mobileTextField.userInteractionEnabled = YES;
        [_mobileTextField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [_mobileTextField addTarget:self action:@selector(textFieldTextDidEndOnExit:) forControlEvents:UIControlEventEditingDidEnd];
        
         [_mobileTextField addTarget:self action:@selector(textFieldTextDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        
    }
    
    return _mobileTextField;
}
-(UILabel *)detailL
{
    if (!_detailL) {
        _detailL = [UILabel new];
        _detailL.text = @"";
        _detailL.font = [UIFont systemFontOfMutableSize:12];
        _detailL.textColor = FONTCOLOR;
        [_detailL sizeToFit];
    }
    
    return _detailL;
}
-(UIButton *)contactButton
{
    if (!_contactButton) {
        _contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contactButton setImage:[UIImage imageNamed:@"联系人"] forState:UIControlStateNormal];
        [_contactButton.imageView sizeToFit];
        _contactButton.userInteractionEnabled = YES;
        [_contactButton addTarget:self action:@selector(contact) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactButton;
}
-(UIImageView *)bottomLineImg
{
    if (!_bottomLineImg) {
        _bottomLineImg = [UIImageView new];
        _bottomLineImg.backgroundColor = LAYERCOLOR;
    }
    return _bottomLineImg;
}
-(void)layoutSubviews
{
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_offset(-LEFTSPACE*4);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-5);
    }];
    
    [self.detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(LEFTSPACE);
        make.top.mas_equalTo(self.mobileTextField.mas_bottom).offset(2);
    }];
    
    [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(-LEFTSPACE);
    }];
    
    [self.bottomLineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.right.with.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}
-(void)textFieldTextDidBegin:(UITextField *)textField
{
    //开始编辑的时候 把充值金额选项设置成灰色
    if ([self.delegate respondsToSelector:@selector(startRequestMobileApi:)]) {
        [self.delegate startRequestMobileApi:nil];
        
    }
    
}
-(void)textFieldTextDidChange:(UITextField *)textField
{
    self.model.detailTitle = @"";
    self.detailL.text = @"";
    if (textField.text.length > 11) {
            self.mobileTextField.text = [textField.text substringToIndex:11];
    }
    
    self.model.title = textField.text;
    
    
    if (self.mobileTextField.text.length == 11) {
        [self.mobileTextField resignFirstResponder];
        
    }
    
}
-(void)textFieldTextDidEndOnExit:(UITextField *)textField
{
    if (![self.mobileTextField.text isValidateMobile]) {
      
        [MBProgressHUD showText:MSG18];
       
    }else
    {
       
        //开始请求接口  回调方法
        if ([self.delegate respondsToSelector:@selector(startRequestMobileApi:)]) {
            [self.delegate startRequestMobileApi:self.mobileTextField.text];
        }
            
   

    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    return [UITextField textFieldWithPhoneFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    
    return YES;
}

/**
 通讯录
 */
-(void)contact{
    
    if ([self.delegate respondsToSelector:@selector(toSystemContactVC)]) {
        [self.delegate toSystemContactVC];
    }
    
}
-(void)setModel:(YMCollectionModel *)model
{
   
    _model = model;
    self.mobileTextField.text = model.title;
    self.detailL.text = model.detailTitle;
    
}
@end
