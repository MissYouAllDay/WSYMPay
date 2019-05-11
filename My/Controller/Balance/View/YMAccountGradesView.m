//
//  YMAccountGradesView.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/7.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMAccountGradesView.h"
#import "YMRedBackgroundButton.h"

@interface YMAccountGradesView ()

@property (nonatomic, weak) UIView  *contentView;

@property (nonatomic, weak) UILabel *mainTitleLabel;

@property (nonatomic, weak) UILabel *nowMoneyTitleLabel;

@property (nonatomic, weak) UILabel *remainingMoneyTitleLabel;

@property (nonatomic, weak) UILabel *nowMoneyLabel;

@property (nonatomic, weak) UILabel *remainingMoneyLabel;

@property (nonatomic, weak) UILabel *explainLabel;

@property (nonatomic, weak) UIButton *knowMoreButton;

@property (nonatomic, weak) UIButton *quitButton;

@property (nonatomic, weak) YMRedBackgroundButton *upgradeAccountButton;

@property (nonatomic, assign) CGFloat contentViewHeight;

@property (nonatomic, copy) NSString *moneyText;

@end

@implementation YMAccountGradesView

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
    self.backgroundColor   = RGBAlphaColor(0, 0, 0, 0.7);
    self.contentViewHeight = SCREENHEIGHT * 0.5;
    
    UIView *contentView             = [[UIView alloc]init];
    contentView.backgroundColor     = [UIColor whiteColor];
    contentView.layer.cornerRadius  = CORNERRADIUS;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    //退出按钮
    UIButton *quitButton = [[UIButton alloc]init];
    quitButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [quitButton setImage:[UIImage imageNamed:@"quit"] forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:quitButton];
    self.quitButton = quitButton;

    
    UILabel *mainTitleLabel      = [[UILabel alloc]init];
    mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    mainTitleLabel.font          = [UIFont systemFontOfSize:[VUtilsTool fontWithString:19]];
    [contentView addSubview:mainTitleLabel];
    self.mainTitleLabel = mainTitleLabel;
    
    UILabel *nowMoneyTitleLabel      = [[UILabel alloc]init];
    nowMoneyTitleLabel.text          = @"现有额度:";
    nowMoneyTitleLabel.textAlignment = NSTextAlignmentLeft;
    nowMoneyTitleLabel.font          = [UIFont systemFontOfMutableSize:14];
    nowMoneyTitleLabel.textColor     = FONTCOLOR;
    [contentView addSubview:nowMoneyTitleLabel];
    self.nowMoneyTitleLabel = nowMoneyTitleLabel;
    
    UILabel *remainingMoneyTitleLabel      = [[UILabel alloc]init];
    remainingMoneyTitleLabel.text          = @"剩余额度:";
    remainingMoneyTitleLabel.textAlignment = NSTextAlignmentLeft;
    remainingMoneyTitleLabel.font          = [UIFont systemFontOfMutableSize:14];
    remainingMoneyTitleLabel.textColor     = FONTCOLOR;
    [contentView addSubview:remainingMoneyTitleLabel];
    self.remainingMoneyTitleLabel = remainingMoneyTitleLabel;
    
    UILabel *nowMoneyLabel      = [[UILabel alloc]init];
    nowMoneyLabel.text          = @"200,000元/年";
    nowMoneyLabel.textAlignment = NSTextAlignmentRight;
    nowMoneyLabel.font          = [UIFont systemFontOfMutableSize:13];
    nowMoneyLabel.textColor     = FONTCOLOR;
    [contentView addSubview:nowMoneyLabel];
    self.nowMoneyLabel = nowMoneyLabel;
    
    UILabel *remainingMoneyLabel = [[UILabel alloc]init];
    remainingMoneyLabel.text     = @"1000.00元";
    remainingMoneyLabel.textAlignment = NSTextAlignmentRight;
    remainingMoneyLabel.font          = [UIFont systemFontOfMutableSize:13];
    remainingMoneyLabel.textColor     = FONTCOLOR;
    [contentView addSubview:remainingMoneyLabel];
    self.remainingMoneyLabel = remainingMoneyLabel;
    
    UILabel *explainLabel = [[UILabel alloc]init];
    NSString *labelText   = @"根据监管部门要求,实名认证身份信息的\n完善程度不同,享有不同的余额支付额度\n(快捷支付和网银支付不受此条款限额约束)";
    explainLabel.numberOfLines = 0;
    explainLabel.textAlignment = NSTextAlignmentCenter;
    explainLabel.font          = [UIFont systemFontOfMutableSize:11];
    explainLabel.textColor     = FONTCOLOR;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    [attributedString addAttributes:[NSDictionary attributesForUserTextWithlineHeightMultiple:1.3] range:NSMakeRange(0, attributedString.length)];
    explainLabel.attributedText = attributedString;
   
    [explainLabel sizeToFit];
    
    [contentView addSubview:explainLabel];
    self.explainLabel = explainLabel;
    
    UIButton *knowMoreButton = [[UIButton alloc]init];
    [knowMoreButton setTitle:@"了解更多>>" forState:UIControlStateNormal];
    [knowMoreButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    knowMoreButton.titleLabel.font = [UIFont systemFontOfMutableSize:12];
    [knowMoreButton addTarget:self action:@selector(knowMoreButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:knowMoreButton];
    self.knowMoreButton = knowMoreButton;
    
    YMRedBackgroundButton *upgradeAccountButton = [[YMRedBackgroundButton alloc]init];
    [upgradeAccountButton setTitle:@"升级账户" forState:UIControlStateNormal];
    [upgradeAccountButton addTarget:self action:@selector(upgradeAccountButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:upgradeAccountButton];
    self.upgradeAccountButton = upgradeAccountButton;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(self.contentViewHeight);
        make.width.mas_equalTo(SCREENWIDTH * 0.9);
        make.top.mas_equalTo(SCREENHEIGHT * 0.22);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    CGFloat interval = self.contentViewHeight * 0.06;
    
    [self.quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView.mas_right).offset(-interval);
        make.top.equalTo(self.contentView.mas_top).offset(interval / 2);
        make.width.mas_equalTo(interval);
        make.height.mas_equalTo(interval);
        
    }];
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(interval);
        make.top.equalTo(self.quitButton.mas_bottom).offset(LEFTSPACE /2);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(.75);
        make.centerX.equalTo(self.contentView.mas_centerX);
        
    }];
    
    
    [self.nowMoneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainTitleLabel.mas_left).offset(LEFTSPACE);
        make.top.equalTo(self.mainTitleLabel.mas_bottom).offset(interval * 1.5);
        
    }];
    
    [self.nowMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mainTitleLabel.mas_right).offset(-LEFTSPACE);
        make.top.equalTo(self.nowMoneyTitleLabel.mas_top);
    }];
    
    [self.remainingMoneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainTitleLabel.mas_left).offset(LEFTSPACE);
        make.top.equalTo(self.nowMoneyLabel.mas_bottom).offset(interval);
    }];
    
    [self.remainingMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nowMoneyLabel.mas_right);
        make.top.equalTo(self.remainingMoneyTitleLabel.mas_top);
    }];
    
    
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.contentView.mas_width).multipliedBy(.76);
        make.centerX.equalTo(self.contentView.mas_centerX);

        make.top.equalTo(self.remainingMoneyLabel.mas_bottom).offset(interval);
        
    }];
    
    [self.knowMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(interval);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(.25);
        make.right.equalTo(self.explainLabel.mas_right);
        make.top.equalTo(self.explainLabel.mas_bottom).offset(interval);
        
    }];
    
    [self.upgradeAccountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(self.contentView.mas_height).multipliedBy(.14);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(.8);
        make.centerX.equalTo(self.mainTitleLabel.mas_centerX);
        make.top.equalTo(self.knowMoreButton.mas_bottom).offset(interval / 2);
        
    }];
    
}

-(void)upgradeAccountButtonClick
{
    if ([self.delegate respondsToSelector:@selector(accountGradesViewUpgradeAccountButtonDidClick:)]) {
        
        [self.delegate accountGradesViewUpgradeAccountButtonDidClick:self];
    }

}

-(void)quitButtonClick
{
    [self removeFromSuperview];
}

-(void)setAccountType:(NSString *)accountType
{
    _accountType = [accountType copy];
    
    if (!_accountType.length) {
        _accountType = @"1";
    }
    
     NSString *text  = nil;
    self.moneyText = @"万元/年";
    if ([_accountType isEqualToString:@"1"]) {
        self.moneyText = @"元/终身";
        text          = @"您的账户认证级别为I类";
    }
    
    if ([_accountType isEqualToString:@"2"]) {
        
        text          = @"您的账户认证级别为II类";
    }
    
    if ([_accountType isEqualToString:@"3"]) {
        
        text          = @"您的账户认证级别为III类";
        self.contentViewHeight = SCREENHEIGHT * 0.43;
        self.upgradeAccountButton.hidden = YES;
    }
    
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc]initWithString:text];
    [mText addAttribute:NSForegroundColorAttributeName value:NAVIGATIONBARCOLOR range:NSMakeRange(9, mText.length - 9)];
    self.mainTitleLabel.attributedText = mText;

}

-(void)knowMoreButtonDidClick
{
        
    if ([self.delegate respondsToSelector:@selector(accountGradesViewKnowMoreButtonDidClick:)]) {
        
        [self.delegate accountGradesViewKnowMoreButtonDidClick:self];
    }
}

-(void)setAmountLimit:(NSString *)amountLimit
{
    _amountLimit = [amountLimit copy];
    self.nowMoneyLabel.text = [NSString stringWithFormat:@"%@%@",_amountLimit,self.moneyText];
    [self.nowMoneyLabel sizeToFit];
}

-(void)setSurplusAMT:(NSString *)surplusAMT
{
    _surplusAMT = [surplusAMT copy];
    self.remainingMoneyLabel.text = [NSString stringWithFormat:@"%@",_surplusAMT];
    [self.remainingMoneyLabel sizeToFit];
}

@end
