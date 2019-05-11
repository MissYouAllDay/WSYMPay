//
//  YMRechargeSuccessController.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/18.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMBankCardPaySuccessController.h"
#import "YMRedBackgroundButton.h"
@interface YMBankCardPaySuccessController ()
@property (nonatomic, copy) NSString *billTitle;
@end

@implementation YMBankCardPaySuccessController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _billMoney  = @"0.00元";
        _isRecharge = NO;
        _billTitle  = @"申请成功,已提交银行处理";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

-(void)setupSubviews
{
    self.view.backgroundColor  = VIEWGRAYCOLOR;
   
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    UIImageView *successImage = [[UIImageView alloc]init];
    successImage.image        = [UIImage imageNamed:@"success"];
    [successImage sizeToFit];
    [contentView addSubview:successImage];
    
    UILabel *billTitleLabel = [[UILabel alloc]init];
    billTitleLabel.textAlignment  = NSTextAlignmentCenter;
    billTitleLabel.text = self.billTitle;
    billTitleLabel.font = [UIFont systemFontOfMutableSize:20];
    billTitleLabel.numberOfLines  = 0;
    [billTitleLabel sizeToFit];
    [contentView addSubview:billTitleLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.textAlignment  = NSTextAlignmentCenter;
    moneyLabel.text = self.billMoney;
    moneyLabel.textColor = [UIColor blackColor];
    moneyLabel.font      = [UIFont systemFontOfMutableSize:14];
    moneyLabel.numberOfLines  = 0;
    [moneyLabel sizeToFit];
    [contentView addSubview:moneyLabel];
    
    //注册按钮
    YMRedBackgroundButton*finishBtn = [[YMRedBackgroundButton alloc]init];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
    
    
    CGFloat contentViewH = SCREENHEIGHT * 0.35;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(contentViewH);
        make.width.equalTo(self.view.mas_width);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        
    }];
    
    CGFloat interval     = (SCREENHEIGHT * 0.35 - successImage.height - billTitleLabel.height) / 3;
    
    [successImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contentView.mas_top).offset(interval);
        make.centerX.equalTo(contentView.mas_centerX);
        
    }];
    
    [billTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(successImage.mas_bottom).offset(interval/2);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(billTitleLabel.mas_bottom).offset(interval/2);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(SCREENWIDTH*ROWProportion);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.top.equalTo(contentView.mas_bottom).offset(SCREENWIDTH*ROWProportion);
    }];
    
}
-(void)setIsRecharge:(BOOL)isRecharge
{
    _isRecharge = isRecharge;
    NSString *navTitle = nil;
    if (_isRecharge) {
        self.billTitle = @"充值成功";
        navTitle = @"充值成功";
    } else {
        self.billTitle = @"申请成功,已提交银行处理";
        navTitle = @"申请成功";
    }
    self.navigationItem.title = navTitle;
}

-(void)setBillMoney:(NSString *)billMoney
{
    _billMoney = [billMoney copy];
    if ([_billMoney rangeOfString:@"."].location == NSNotFound) {
        _billMoney = [NSString stringWithFormat:@"%@.00",_billMoney];
    }
    
    _billMoney = [NSString stringWithFormat:@"%@元",_billMoney];
}

-(void)finishBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
