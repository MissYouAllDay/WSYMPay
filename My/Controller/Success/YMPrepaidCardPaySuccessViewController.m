//
//  YMPrepaidCardPaySuccessViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/19.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPrepaidCardPaySuccessViewController.h"
#import "YMRedBackgroundButton.h"


@interface YMPrepaidCardPaySuccessViewController ()
@property (nonatomic, strong) UILabel *moneyLabel;
@end

@implementation YMPrepaidCardPaySuccessViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _billMoney  = @"0.00元";
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
    self.navigationItem.title  = @"预付卡充值";
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    UIImageView *successImage = [[UIImageView alloc]init];
    successImage.image        = [UIImage imageNamed:@"success"];
    [successImage sizeToFit];
    [contentView addSubview:successImage];
    
    UILabel *billTitleLabel       = [[UILabel alloc]init];
    billTitleLabel.textAlignment  = NSTextAlignmentCenter;
    billTitleLabel.text           = @"预付卡充值成功";
    billTitleLabel.font           = [UIFont systemFontOfMutableSize:20];
    billTitleLabel.numberOfLines  = 0;
    [billTitleLabel sizeToFit];
    [contentView addSubview:billTitleLabel];
    
    self.moneyLabel = [[UILabel alloc]init];
    self.moneyLabel.textAlignment  = NSTextAlignmentCenter;
    self.moneyLabel.text           = self.billMoney;
    self.moneyLabel.textColor      = [UIColor blackColor];
    self.moneyLabel.font           = [UIFont systemFontOfMutableSize:14];
    self.moneyLabel.numberOfLines  = 0;
    [self.moneyLabel sizeToFit];
    [contentView addSubview:self.moneyLabel];
    
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
    
    CGFloat interval = (SCREENHEIGHT * 0.35 - successImage.height - billTitleLabel.height) / 3;
    
    [successImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contentView.mas_top).offset(interval);
        make.centerX.equalTo(contentView.mas_centerX);
        
    }];
    
    [billTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(successImage.mas_bottom).offset(interval/2);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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


-(void)setBillMoney:(NSString *)billMoney
{
    _billMoney = [billMoney copy];
    if ([_billMoney rangeOfString:@"."].location == NSNotFound) {
        _billMoney = [NSString stringWithFormat:@"%@.00",_billMoney];
    }
    _billMoney = [NSString stringWithFormat:@"%@元",_billMoney];
    self.moneyLabel.text = _billMoney;
}

-(void)finishBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
