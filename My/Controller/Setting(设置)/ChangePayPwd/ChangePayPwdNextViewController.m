//
//  ChangePayPwdNextViewController.m
//  WSYMPay
//
//  Created by MaKuiying on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "ChangePayPwdNextViewController.h"
#import "DetailPayPwdViewController.h"
#import "YMUserInfoTool.h"
#import "YMResponseModel.h"
#import "YMIDTextField.h"
#define IDMSG1 @"身份证输入有误请检查后重\n新输入"
#define IDMSG2 @"您输入的身份证号与实名信息不一致\n请检查后输入"
@interface ChangePayPwdNextViewController ()<UITextFieldDelegate>{
    
    YMIDTextField *identityTF;
    UIButton      *nextBtn ;
    UILabel       *account;
}
@end
@implementation ChangePayPwdNextViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:VIEWGRAYCOLOR];
    self.navigationItem.title = @"修改支付密码";
    [self initViews];
}
- (void)initViews {
    
    
    //账户名
    identityTF = [[YMIDTextField alloc]init];
    identityTF.placeholder = @"请输入您本人的身份证号";
    identityTF.borderStyle = UITextBorderStyleNone;
    identityTF.font        = [UIFont systemFontOfMutableSize:14];
    identityTF.textColor   = [UIColor grayColor];
    identityTF.layer.borderWidth = 1.0;
    identityTF.layer.borderColor = LAYERCOLOR.CGColor;
    [identityTF setValue:[UIFont systemFontOfMutableSize:14] forKeyPath:@"_placeholderLabel.font"];
    [identityTF addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];
    identityTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:identityTF];
    [identityTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(LEFTSPACE);
        make.height.offset(SCREENWIDTH*ROWProportion);
    }];
  
    account = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 22, 45)];
    account.font = [UIFont systemFontOfMutableSize:14];
    account.backgroundColor = [UIColor clearColor];
    identityTF.leftView = account;
    
    //下一步
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
    [nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(identityTF.mas_bottom).offset(15);
        make.height.equalTo(nextBtn.mas_width).multipliedBy(0.144);
    }];
}


- (void)nextBtn{
    [self hideKeyboard];
    [self.view endEditing:YES];
    if ([VUtilsTool validateIdentityCard:identityTF.text] == NO) {
        [MBProgressHUD showText:IDMSG1];
        return;
    }
    
    YMUserInfoTool* currentUserInfo = [YMUserInfoTool shareInstance];
    
    RequestModel *params = [[RequestModel alloc]init];
    params.custLogin     = currentUserInfo.custLogin;
    params.idCardNum     = identityTF.text;
    params.token         = currentUserInfo.token;
    params.randomCode    = [YMUserInfoTool shareInstance].randomCode;;
    params.tranCode      = CHANGEMOBILEVIDCARD;
    [MBProgressHUD show];
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        YMLog(@"%@",responseObject);
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {
            DetailPayPwdViewController * detailVC = [[DetailPayPwdViewController alloc]init];
            [self.navigationController pushViewController:detailVC animated:YES];
        } else if (m.resCode == 37){
            [MBProgressHUD showText:MSG13];
        } else {
            [MBProgressHUD showText:m.resMsg];
        }
        

    } failure:^(NSError *error) {}];
    
}

- (void)hideKeyboard {
    [identityTF resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
}


#pragma mark - UITextFieldDelegate
-(void)textFieldDidEditing:(UITextField *)tf{
    
    if (tf.text.length >= 18) {
        tf.text = [tf.text substringToIndex:18];
    }
    
    if (tf.text.length > 10) {
        nextBtn.enabled = YES;
    } else {
        nextBtn.enabled = NO;
    }
  
    
}



@end
