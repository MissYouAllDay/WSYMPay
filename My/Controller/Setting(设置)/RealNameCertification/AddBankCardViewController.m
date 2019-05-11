//
//  AddBankCardViewController.m
//  WSYMPay
//
//  Created by MaKuiying on 16/9/22.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "AddCardDetailViewController.h"
#import "YMUserInfoTool.h"
#import "YMResponseModel.h"
#define AUTHMSG1 @"您已绑定该银行卡"
#define AUTHMSG2 @"暂不支持该银行卡，请使用其他银行卡"
#import "YMBankCardModel.h"
#import "UITextField+Extension.h"
@interface AddBankCardViewController ()<UITextFieldDelegate>

@end

@implementation AddBankCardViewController{
    
    UITextField * addBankCardTF;
    UIButton * nextBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:VIEWGRAYCOLOR];
    self.title = @"添加银行卡";
    [self initViews];
}

- (void)initViews {
  
    addBankCardTF = [[UITextField alloc]init];
    addBankCardTF.placeholder = @"请输入持卡人本人的银行卡号";
    addBankCardTF.layer.borderColor = LAYERCOLOR.CGColor;
    addBankCardTF.layer.borderWidth = 1.0;
    addBankCardTF.layer.cornerRadius = 0;
    addBankCardTF.borderStyle = UITextBorderStyleNone;
    addBankCardTF.font = [UIFont systemFontOfMutableSize:14];
    addBankCardTF.keyboardType = UIKeyboardTypeNumberPad;
    addBankCardTF.backgroundColor = [UIColor whiteColor];
    addBankCardTF.delegate = self;
    UILabel * userIconView = [UILabel new];
    userIconView.frame = CGRectMake(0, 0, 60, 45);
    userIconView.textColor = [UIColor grayColor];
    userIconView.text = @"卡号";
    userIconView.font = [UIFont systemFontOfMutableSize:14];
    userIconView.textAlignment = NSTextAlignmentCenter;
    addBankCardTF.leftViewMode = UITextFieldViewModeAlways;
    addBankCardTF.leftView = userIconView;
    [addBankCardTF addTarget:self action:@selector(addBankCardEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:addBankCardTF];
    
    [addBankCardTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(LEFTSPACE);
        make.height.equalTo(addBankCardTF.mas_width).multipliedBy(0.145);
    }];

    UILabel * markL = [UILabel new];
    [self.view addSubview:markL];
    markL.font = [UIFont systemFontOfSize:DEFAULTFONT(12)];
    markL.backgroundColor = [UIColor clearColor];
    markL.textColor = [UIColor grayColor];
    markL.text = @"信息加密处理，仅用于银行验证";
    [markL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(addBankCardTF.mas_bottom).offset(10);
        make.height.offset(22);
    }];

    
    nextBtn = [UIButton new];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"register"] forState:UIControlStateDisabled];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login_seclected"] forState:UIControlStateHighlighted];
    nextBtn.enabled = NO;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    nextBtn.titleLabel.font = [UIFont systemFontOfMutableSize:14];
    nextBtn.layer.cornerRadius = CORNERRADIUS;
    [nextBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(markL.mas_bottom).offset(20);
        make.height.equalTo(nextBtn.mas_width).multipliedBy(0.144);
    }];

}

- (void)sure:(UIButton*)btn{
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:@"正在验证"];
    NSString* str        = [addBankCardTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    RequestModel *params = [[RequestModel alloc]init];
    params.token         = [YMUserInfoTool shareInstance].token;
    params.bankAcNo      = str;
    params.tranCode      = GETBANKCARDBINFO;
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {
            [MBProgressHUD showText:m.resMsg];
            AddCardDetailViewController* addVC = [[AddCardDetailViewController alloc]init];
            
            YMBankCardModel *bankCard = [[YMBankCardModel alloc]init];
            bankCard.bankCardType     = m.bankCardType;
            bankCard.bankNo           = m.bankNo;
            bankCard.bankName         = m.bankName;
            bankCard.cardType         = m.cardType;
            bankCard.bankAcNo         = addBankCardTF.text;
            addVC.bankCardInfo        = bankCard;

            
       
            [self.navigationController pushViewController:addVC animated:YES];
        } else {
            
            [MBProgressHUD showText:m.resMsg];
        }

    } failure:^(NSError *error) {
    }];
    
}

-(void)addBankCardEditingChanged:(UITextField *)textfield
{
    NSString *newString = [textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (newString.length > 15) {
        nextBtn.enabled = YES;
    }else {
        nextBtn.enabled = NO;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [UITextField textFieldWithBankCardFormat:textField shouldChangeCharactersInRange:range replacementString:string];
}

@end
