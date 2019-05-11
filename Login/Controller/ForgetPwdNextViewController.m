//
//  ForgetPwdNextViewController.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 16/9/18.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "ForgetPwdNextViewController.h"
#import "LandViewController.h"
#import "YMResponseModel.h"
@interface ForgetPwdNextViewController ()<UITextFieldDelegate>
{
    UITextField * pwdTF;
    UIButton * sureBtn;
    
}

@end

@implementation ForgetPwdNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:VIEWGRAYCOLOR];
    self.title = @"忘记密码";
    [self initViews];

    // Do any additional setup after loading the view.
}
-(void)initViews
{
    UITextField * pwdtf = [UITextField new];
    pwdTF = pwdtf;
    pwdtf.placeholder = @"请输入新的登录密码";
    pwdtf.layer.borderColor = LAYERCOLOR.CGColor;
    pwdtf.layer.borderWidth = 1.0;
    pwdtf.layer.cornerRadius = CORNERRADIUS;
    pwdtf.borderStyle = UITextBorderStyleNone;
    pwdtf.secureTextEntry = YES;
    pwdtf.delegate = self;
    pwdtf.font = [UIFont systemFontOfMutableSize:14];
    pwdtf.keyboardType = UIKeyboardTypeDefault;
    pwdtf.backgroundColor = [UIColor whiteColor];
//    pwdtf.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:pwdtf];
    UIImageView * userIconView = [UIImageView new];
    userIconView.frame = CGRectMake(0, 0, 15, 15);
    pwdtf.leftViewMode = UITextFieldViewModeAlways;
    pwdtf.leftView = userIconView;
    [self.view addSubview:pwdtf];
    
    [pwdtf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.offset(LEFTSPACE);
        make.height.equalTo(pwdtf.mas_width).multipliedBy(0.145);
    }];
    
    UIButton * secuBtn = [UIButton new];
    [secuBtn addTarget:self action:@selector(secuBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secuBtn];
    [secuBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [secuBtn setBackgroundImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
    secuBtn.selected = NO;
    [secuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.centerY.equalTo(pwdtf.mas_centerY);
        make.width.equalTo(pwdtf.mas_height).multipliedBy(0.6);
        make.height.equalTo(secuBtn.mas_width).multipliedBy(0.8);
        
    }];
    
    UILabel * markL = [UILabel new];
    [self.view addSubview:markL];
    markL.font = [UIFont systemFontOfSize:DEFAULTFONT(12)];
    markL.backgroundColor = [UIColor clearColor];
    markL.textColor = [UIColor grayColor];
    markL.text = @"8-20位,数字、字母、特殊字符三种组合";
    
    [markL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE*2);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(pwdtf.mas_bottom).offset(10);
        make.height.offset(22);
    }];
    
    UIButton * nextBtn = [UIButton new];
    sureBtn = nextBtn;
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"register"] forState:UIControlStateDisabled];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login_seclected"] forState:UIControlStateHighlighted];
    nextBtn.enabled = NO;
    [nextBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    nextBtn.titleLabel.font = [UIFont systemFontOfMutableSize:14];
    nextBtn.layer.cornerRadius = CORNERRADIUS;
   
    [nextBtn addTarget:self action:@selector(nextSure:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(markL.mas_bottom).offset(20);
        make.height.equalTo(nextBtn.mas_width).multipliedBy(0.144);
    }];
}

-(void)textFieldChanged:(NSNotification *) note
{
    UITextField * textF =  note.object;
    NSString * content = textF.text;
    if (textF == pwdTF) {
        if ( content.length > 7) {
            sureBtn.enabled = YES;
        }else
        {
            sureBtn.enabled = NO;
        }
    }
}
-(void)secuBtnTouchUp:(UIButton *)sender
{
    if (sender.selected) {
        pwdTF.secureTextEntry = YES;
    }else
    {
        pwdTF.secureTextEntry = NO;
    }
    sender.selected = !sender.selected;
    
}
-(void)nextSure:(UIButton *)sender
{
    
    if (!pwdTF.text.isPasswordFormat) {
        [MBProgressHUD showText:@"登录密码需8-20位数字、字母、特殊字符三种组合"];
        return;
    }
    
    _params.newCustPwd = pwdTF.text;
    _params.tranCode    = FORGETPWDSETNEWPWD;

    [MBProgressHUD show];
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:_params success:^(id responseObject) {
        
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {
            [MBProgressHUD showText:m.resMsg];
            NSArray *temArray = self.navigationController.viewControllers;
            for(UIViewController *temVC in temArray)
            {
              if ([temVC isKindOfClass:[LandViewController class]])
                {
                    [self.navigationController popToViewController:temVC animated:YES];
                }
            }
        } else {
                        
             [MBProgressHUD showText:m.resMsg];
            }

    } failure:^(NSError *error) {}];
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString* toStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toStr.length == 21) {
        return NO;
    }
   
    return YES;
}

@end
