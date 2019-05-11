//
//  YMCashierDeskView.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/18.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMCashierDeskView.h"
#import "YMRightOfImageButton.h"
#import "YMRedBackgroundButton.h"
@interface YMCashierDeskView()
@property (nonatomic, weak) UIButton *quitButton;

@property (nonatomic, weak) UILabel  *mainTitleLabel;

@property (nonatomic, weak) UIView   *lineView;

@property (nonatomic, weak) UIView   *boxView;

@property (nonatomic, weak) UILabel  *subTitleLabel;

@property (nonatomic, weak) UILabel *moneyLabel;

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UILabel *transactionModeLabel;

@property (nonatomic, weak) YMRightOfImageButton *bankCardInfoButton;

@property (nonatomic, weak) YMRedBackgroundButton *registerBtn;
@end


@implementation YMCashierDeskView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews
{
    
    self.backgroundColor     = RGBAlphaColor(13, 13, 13, 0.5);
    self.layer.masksToBounds = YES;
    
    UIView *boxView         = [[UIView alloc]init];
    boxView.backgroundColor = [UIColor whiteColor];
    [self addSubview:boxView];
    self.boxView = boxView;
    
    
    UILabel *mainTitleLabel  = [[UILabel alloc]init];
    mainTitleLabel.textColor = FONTDARKCOLOR;
    mainTitleLabel.font      = [UIFont systemFontOfSize:[VUtilsTool fontWithString:16] weight:0.015];
    mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    mainTitleLabel.text      = @"支付详情";
    [boxView addSubview:mainTitleLabel];
    self.mainTitleLabel = mainTitleLabel;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBAlphaColor(0, 0, 0, 0.15);
    [boxView addSubview:lineView];
    self.lineView = lineView;
    
    
    //退出按钮
    UIButton *quitButton = [[UIButton alloc]init];
    quitButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [quitButton setImage:[UIImage imageNamed:@"quit"] forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [boxView addSubview:quitButton];
    self.quitButton = quitButton;
    
    UILabel *subTitleLabel  = [[UILabel alloc]init];
    subTitleLabel.textColor = FONTCOLOR;
    subTitleLabel.font      = [UIFont systemFontOfSize:[VUtilsTool fontWithString:16] weight:0.015];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.text      = @"预付卡充值";
    [subTitleLabel sizeToFit];
    [boxView addSubview:subTitleLabel];
    self.subTitleLabel = subTitleLabel;
    
    UILabel *moneyLabel  = [[UILabel alloc]init];
    moneyLabel.textColor = FONTDARKCOLOR;
    moneyLabel.font      = [UIFont systemFontOfSize:[VUtilsTool fontWithString:23] weight:0.012];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.text      = @"¥100.0";
    [moneyLabel sizeToFit];
    [boxView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    UIView *contentView = [[UIView alloc]init];
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = RGBAlphaColor(0, 0, 0, 0.15).CGColor;
    [boxView addSubview:contentView];
    self.contentView = contentView;
    
    UILabel *transactionModeLabel  = [[UILabel alloc]init];
    transactionModeLabel.textColor = FONTCOLOR;
    transactionModeLabel.font      = [UIFont systemFontOfSize:[VUtilsTool fontWithString:15] weight:0.01];
    transactionModeLabel.textAlignment = NSTextAlignmentLeft;
    transactionModeLabel.text      = @"支付方式";
    [transactionModeLabel sizeToFit];
    [contentView addSubview:transactionModeLabel];
    self.transactionModeLabel = transactionModeLabel;
    
    YMRightOfImageButton *bankCardInfoButton  = [[YMRightOfImageButton alloc]init];
    [bankCardInfoButton setTitleColor:FONTCOLOR forState:UIControlStateNormal];;
    bankCardInfoButton.titleLabel.font      = [UIFont systemFontOfSize:[VUtilsTool fontWithString:15] weight:0.01];
    bankCardInfoButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [bankCardInfoButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [bankCardInfoButton setTitle:@"余额支付" forState:UIControlStateNormal];
    [bankCardInfoButton addTarget:self action:@selector(bankCardInfoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bankCardInfoButton sizeToFit];
    [contentView addSubview:bankCardInfoButton];
    self.bankCardInfoButton = bankCardInfoButton;
    
    //注册按钮
    YMRedBackgroundButton*registerBtn = [[YMRedBackgroundButton alloc]init];
    [registerBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [boxView addSubview:registerBtn];
    self.registerBtn = registerBtn;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height   = SCREENHEIGHT * 0.06;
    CGFloat interval = height * 0.1;
    
    
    self.boxView.x      = 0;
    self.boxView.width  = SCREENWIDTH;
    self.boxView.height = SCREENHEIGHT * 0.3 + 216;
    self.boxView.y      = SCREENHEIGHT - self.boxView.height;
    
    self.mainTitleLabel.width   = self.width * 0.4;
    self.mainTitleLabel.height  = height;
    self.mainTitleLabel.y       = interval;
    self.mainTitleLabel.centerX = self.width * 0.5;
    
    self.quitButton.x     = interval;
    self.quitButton.y     = interval;
    self.quitButton.width = self.quitButton.height = height;
    
    self.lineView.y      = self.mainTitleLabel.bottom + interval;
    self.lineView.x      = 0;
    self.lineView.width  = self.width;
    self.lineView.height = 1;
    
    self.subTitleLabel.centerX = self.width * 0.5;
    self.subTitleLabel.y       = CGRectGetMaxY(self.lineView.frame) + LEFTSPACE * 2;
    
    self.moneyLabel.centerX = self.width * 0.5;
    self.moneyLabel.y       = CGRectGetMaxY(self.subTitleLabel.frame) + LEFTSPACE/2;
    
    self.contentView.width   = self.width + 10;
    self.contentView.height  = height * 1.2;
    self.contentView.centerX = self.width * 0.5;
    self.contentView.y       = CGRectGetMaxY(self.moneyLabel.frame) + LEFTSPACE * 2;
    
    self.transactionModeLabel.x = LEFTSPACE;
    self.transactionModeLabel.centerY = self.contentView.height / 2;
    
    self.bankCardInfoButton.x = self.width - self.bankCardInfoButton.width - LEFTSPACE;
    self.bankCardInfoButton.width = self.bankCardInfoButton.width + 5;
    self.bankCardInfoButton.centerY = self.contentView.height /2;
    
    self.registerBtn.width   = self.width * 0.85;
    self.registerBtn.height  = SCREENWIDTH*ROWProportion;
    self.registerBtn.centerX = self.width * 0.5;
    self.registerBtn.y       = CGRectGetMaxY(self.contentView.frame) + LEFTSPACE * 2;
}

-(void)show
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self show];
            
        });
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = keyWindow.bounds;
    [keyWindow addSubview:self];
    
}

-(void)remove
{
    [self removeFromSuperview];
}

-(void)quitButtonClick
{
    [self removeFromSuperview];
}

-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}

-(void)registerBtnClick
{
    if ([self.delegate respondsToSelector:@selector(cashierDeskViewDeterminePaymentButtonDidClick:)]) {
        [self.delegate cashierDeskViewDeterminePaymentButtonDidClick:self];
    }
}
//选择支付方式：
-(void)bankCardInfoButtonClick
{
    if ([self.delegate respondsToSelector:@selector(cashierDeskViewSelecterBankCardButtonDidClick:)]) {
        [self.delegate cashierDeskViewSelecterBankCardButtonDidClick:self];
    }
}
-(void)setRechargeMoney:(NSString *)rechargeMoney
{
    _rechargeMoney = [rechargeMoney copy];
    _rechargeMoney = [NSString stringWithFormat:@"¥%@",_rechargeMoney];
    self.moneyLabel.text = _rechargeMoney;
    [self.moneyLabel sizeToFit];
    [self setNeedsLayout];
}

-(void)setBankInfo:(NSString *)bankInfo
{
    _bankInfo = [bankInfo copy];
    [self.bankCardInfoButton setTitle:_bankInfo forState:UIControlStateNormal];
    [self.bankCardInfoButton sizeToFit];
    [self setNeedsLayout];
}

-(void)setMainTitle:(NSString *)mainTitle
{
    _mainTitle = [mainTitle copy];
    self.subTitleLabel.text = _mainTitle;
    [self.subTitleLabel sizeToFit];
    
}

@end
