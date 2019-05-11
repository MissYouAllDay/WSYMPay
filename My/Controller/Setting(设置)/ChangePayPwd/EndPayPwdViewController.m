//
//  EndPayPwdViewController.m
//  WSYMPay
//
//  Created by MaKuiying on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "EndPayPwdViewController.h"
#import "DXInputPasswordView.h"
#import "MyViewController.h"
#import "DetailPayPwdViewController.h"
#import "YMUserInfoTool.h"
#import "YMResponseModel.h"
@interface EndPayPwdViewController ()<DXInputPasswordViewDelegate>

@property(nonatomic,strong)DXInputPasswordView* inputpwdView;

@end

@implementation EndPayPwdViewController{
    
    NSString* paymentString;
    NSInteger pwdLength;//密码长度
    NSTimer*_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:VIEWGRAYCOLOR];
    self.title = @"修改支付密码";
    [self initViews];
}

- (void)initViews {
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"再次确认密码";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:[VUtilsTool fontWithString:14.0]];
    [self.view addSubview:label];
    
    self.inputpwdView = [[DXInputPasswordView alloc]initWithFrame:CGRectMake(15, label.frame.size.height+30, SCREENWIDTH-30,SCREENWIDTH*ROWProportion)];
    self.inputpwdView.intervalLineColor     = LAYERCOLOR;
    self.inputpwdView.borderColor           = LAYERCOLOR;
    self.inputpwdView.layer.cornerRadius    = CORNERRADIUS;
    self.inputpwdView.delegate              = self;
    [self.inputpwdView becomeFirstResponder];
    [self.view addSubview:self.inputpwdView];

}

-(void)inputPasswordView:(DXInputPasswordView *)inputPasswordView completeInput:(NSString *)str
{
    if (str.length == 6) {
        if (![str isEqualToString:self.firstPayPwdStr]) {
            [MBProgressHUD showText:@"两次输入密码不一致"];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pop) userInfo:nil repeats:YES];
            return;
        }else{
            
            RequestModel *params = [[RequestModel alloc]init];
            params.custLogin     = [[YMUserInfoTool shareInstance] custLogin];
            params.token         = [[YMUserInfoTool shareInstance] token];
            params.randomCode    = [YMUserInfoTool shareInstance].randomCode;;
            params.newPayPwd     = str;
            params.tranCode      = SETTINGNEWPAYPWD;
            [MBProgressHUD show];
            [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
                [MBProgressHUD hideHUD];
                YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
               
                if (m.resCode == 1) {
                    
                    [MBProgressHUD showText:m.resMsg];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //获取当前controller的索引
                        NSInteger index = self.navigationController.viewControllers.count - 1;
                        UIViewController *popToVC = self.navigationController.viewControllers[index - 4];
                        [self.navigationController popToViewController:popToVC animated:YES];
                    });
                    
                } else {
                    
                    [MBProgressHUD showText:m.resMsg];
                }

            } failure:^(NSError *error) {}];
            
            
        }
    }


}


- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
