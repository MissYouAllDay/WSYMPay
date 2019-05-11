//
//  SettingAmountVC.m
//  WSYMPay
//
//  Created by junchiNB on 2019/4/21.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import "SettingAmountVC.h"
#import "YMRedBackgroundButton.h"
#import "YMTextField.h"
@interface SettingAmountVC ()<UITextFieldDelegate>
@property (nonatomic,strong)YMTextField *txtF;
@property (nonatomic,strong)YMRedBackgroundButton *finshBtn;
@end

@implementation SettingAmountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.txtF];
    self.view.backgroundColor=[UIColor whiteColor];
//    self.view.backgroundColor = NAVIGATIONBARCOLOR;
    self.title = @"设置金额";
    [_txtF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(64);
        make.left.mas_equalTo(self.view).mas_offset(14);
        make.right.mas_equalTo(self.view).mas_offset(-14);
    }];
    UIView *bottomLineView3 = [[UIView alloc]init];
    bottomLineView3.backgroundColor = LAYERCOLOR;
    [self.view addSubview:bottomLineView3];
    [bottomLineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.txtF);
        make.top.mas_equalTo(self.txtF.mas_bottom).mas_offset(4);
        make.height.mas_equalTo(1);
    }];
    [self.view addSubview:self.finshBtn];
    [_finshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtF.mas_bottom).mas_offset(36);
        make.left.mas_equalTo(self.view).mas_offset(14);
        make.right.mas_equalTo(self.view).mas_offset(-14);
        make.height.mas_equalTo(45);
    }];
}


-(void)textFieldTextDidChange:(UITextField *)textField
{
    if(textField.text.length>0) {
        self.finshBtn.enabled=YES;
    }    
}
-(void)finshAction {
    self.settingAmountBlock(self.txtF.text);
    [self.navigationController popViewControllerAnimated:YES];
}
-(YMTextField *)txtF {
    if(!_txtF) {
       _txtF = [[YMTextField alloc]init];
//        _txtF.borderStyle  = UITextBorderStyleNone;
        _txtF.placeholder  = @"";
        _txtF.font         = COMMON_FONT;
        _txtF.leftTitle=@"金额";
        _txtF.delegate=self;
        [_txtF setValue:[UIFont systemFontOfMutableSize:14] forKeyPath:@"_placeholderLabel.font"];
        _txtF.keyboardType =UIKeyboardTypeDecimalPad;
        [_txtF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _txtF;
}

-(YMRedBackgroundButton *)finshBtn {
    if(!_finshBtn) {
       _finshBtn = [[YMRedBackgroundButton alloc]init];
        _finshBtn.enabled               = NO;
        [_finshBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finshBtn addTarget:self action:@selector(finshAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _finshBtn;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
