//
//  YMGetVerificationCodeController.m
//  WSYMPay
//
//  Created by W-Duxin on 16/11/17.
//  Copyright © 2016年 赢联. All rights reserved.
//
#warning mark - 更改此类时注意所有继承这个类的情况

#import "YMChangeGetVCodeController.h"
#import "VerificationView.h"
#import "YMRedBackgroundButton.h"
#import "UITextField+Extension.h"
@interface YMChangeGetVCodeController ()<UITextFieldDelegate,VerificationViewDelegate>

@property (nonatomic, weak) UILabel *leftTitleLabel;

@end

@implementation YMChangeGetVCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initViews];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (self.isNotFirstLoad && _verificationView.verificationCode.length == 0 && _verificationView.isCountDown) {
        
        [MBProgressHUD showText:MSG2];
    }
}

-(void)initViews
{
    UIView * allViews           = [UIView new];
    allViews.layer.borderWidth  = 1.0;
    allViews.layer.borderColor  = LAYERCOLOR.CGColor;
    allViews.layer.cornerRadius = 0;
    allViews.backgroundColor    = [UIColor whiteColor];
    [self.view addSubview:allViews];
    
    UITextField * userName = [UITextField new];
    userName.placeholder   = @"请输入手机号";
    userName.borderStyle   = UITextBorderStyleNone;
    userName.font          = COMMON_FONT;
    userName.delegate      = self;
    userName.tag           = 73;
    userName.leftViewMode  = UITextFieldViewModeAlways;
    [userName addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [allViews addSubview:userName];
    UILabel* account       = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 45)];
    account.textAlignment  = NSTextAlignmentLeft;
    account.text           = @"手机号";
    account.textColor      = [UIColor grayColor];
    account.font           = COMMON_FONT;
    userName.leftView      = account;
    _userNameTF            = userName;
    _leftTitleLabel        = account;
    
    UIImageView * lineImg   = [[UIImageView alloc]init];
    lineImg.backgroundColor = LAYERCOLOR;
    [self.view addSubview:lineImg];
    [allViews addSubview:lineImg];
    
    
    VerificationView *verificationView = [[VerificationView alloc]init];
    verificationView.delegate          = self;
    verificationView.showLeftTitlt     = YES;
    [allViews addSubview:verificationView];
    self.verificationView              = verificationView;
    
    [allViews addSubview:verificationView];
    
    YMRedBackgroundButton * nextBtn = [[YMRedBackgroundButton alloc]init];
    nextBtn.enabled                 = NO;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextButtonDidClick)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    _nextButton = nextBtn;
    
    //底部白色界面
    [allViews mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(LEFTSPACE);
        make.height.equalTo(allViews.mas_width).multipliedBy(0.267);
        
    }];
    //用户名输入框
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.equalTo(allViews.mas_bottom).multipliedBy(0.5);
    }];
    
    //分隔线
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(0);
        make.centerY.equalTo(allViews.mas_centerY);
        make.height.offset(1);
    }];
    
    //验证码界面
    [verificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-LEFTSPACE);
        make.top.equalTo(lineImg.mas_bottom);
        make.bottom.offset(0);
    }];
    
    //下一步按钮
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(allViews.mas_bottom).offset(30);
        make.height.equalTo(nextBtn.mas_width).multipliedBy(0.144);
    }];
}

-(void)nextButtonDidClick
{
    [self.view endEditing:YES];

    
}
-(void)textFieldChanged:(UITextField *)textField
{
    if (textField.tag == 73) {
        if ( _userNameTF.text.length == 13 && self.verificationView.verificationCode.length == 6) {
            _nextButton.enabled = YES;

        } else {
            _nextButton.enabled = NO;
        }
    } else {

        if ( _userNameTF.text.length > 5 && self.verificationView.verificationCode.length == 6) {
            
            _nextButton.enabled = YES;

        } else {
            _nextButton.enabled = NO;
        }

    }
    
    
}

#pragma mark VerificationViewDelegate
//验证码输入
-(void)verificationViewTextDidEditingChange:(NSString *)text
{
    
//    if (_userNameTF.tag == 73) {
//        if ( _userNameTF.text.length == 13 && text.length == 6) {
//            _nextButton.enabled = YES;
//
//        } else {
//            _nextButton.enabled = NO;
//        }
//    } else {
    
    NSLog(@"-----------%@",text);
    NSLog(@"text=--------%lu,",(unsigned long)text.length);

        if ( text.length > 5 && text.length == 6) {
            _nextButton.enabled = YES;
            
        } else {
            _nextButton.enabled = NO;
        }
//    }
}
//倒计时按钮点击
-(void)verificationViewCountdownButtonDidClick:(VerificationView *)verificationView
{
    [self loadCerCode];
  
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

}

-(void)loadCerCode
{
    [self.view endEditing:YES];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 73) {
        return [UITextField textFieldWithPhoneFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    } else if (textField.tag == 100) {
    
        NSString* toStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if(toStr.length > 30){
            
            return NO;
        }
    
    }
        
    return YES;
}

-(void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = [leftTitle copy];
    
    self.leftTitleLabel.text = _leftTitle;

}


@end
