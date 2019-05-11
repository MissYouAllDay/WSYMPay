//
//  DetailPayPwdViewController.m
//  WSYMPay
//
//  Created by MaKuiying on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "DetailPayPwdViewController.h"
#import "DXInputPasswordView.h"
#import "EndPayPwdViewController.h"
#define NOTRepetitionStr @"支付密码不能使用相同的数字"
#define NOTContinuation  @"支付密码不能使用连续的数字"
@interface DetailPayPwdViewController ()<DXInputPasswordViewDelegate>

@property(nonatomic,strong)DXInputPasswordView *inputpwdView;

@end

@implementation DetailPayPwdViewController{
    
    NSString* paymentString;
    UILabel* label;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:VIEWGRAYCOLOR];
    self.title = @"修改支付密码";
    [self initViews];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.inputpwdView becomeFirstResponder];

}

- (void)initViews {
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"设置6位数字支付密码";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfMutableSize:14];
    [self.view addSubview:label];

    
    self.inputpwdView = [[DXInputPasswordView alloc]initWithFrame:CGRectMake(15, label.frame.size.height+30, SCREENWIDTH-30,SCREENWIDTH*ROWProportion)];
    self.inputpwdView.intervalLineColor     = LAYERCOLOR;
    self.inputpwdView.borderColor           = LAYERCOLOR;
    self.inputpwdView.layer.cornerRadius    = CORNERRADIUS;
    self.inputpwdView.delegate              = self;
    [self.view addSubview:self.inputpwdView];
   
}
-(void)inputPasswordView:(DXInputPasswordView *)inputPasswordView completeInput:(NSString *)str{
    [inputPasswordView clearUpPassword];
    if (str.length == 6) {
       if (![VUtilsTool isValidateRepeatPayPwd:str]) {
        [MBProgressHUD showText:NOTRepetitionStr];
        return ;
        }
    if (![VUtilsTool isValidateContinuousPayPwd:str]) {
        [MBProgressHUD showText:NOTContinuation];
        return;
        }
    EndPayPwdViewController * endVC = [[EndPayPwdViewController alloc]init];
    endVC.firstPayPwdStr = str;
    [self.navigationController pushViewController:endVC animated:YES];
  }
}


@end
