//
//  YMHomeTopView.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMHomeTopView.h"
#import "YMCardButton.h"
@interface YMHomeTopView ()

@property (nonatomic, weak) YMCardButton *scanBtn;

@property (nonatomic, weak) YMCardButton *payCodeBtn;

@property (nonatomic, weak) YMCardButton *cardPackageBtn;
@property (nonatomic, weak) YMCardButton *receiveCodeBtn;

@end

@implementation YMHomeTopView

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
    
    self.backgroundColor = NAVIGATIONBARCOLOR;
    
    YMCardButton *scanBtn = [[YMCardButton alloc]init];
    scanBtn.tag           = 0;
    [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scanBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
    [scanBtn setImage:[UIImage imageNamed:@"home_扫一扫"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:scanBtn];
    self.scanBtn = scanBtn;
    
    YMCardButton *payCodeBtn = [[YMCardButton alloc]init];
    payCodeBtn.tag           = 1;
    [payCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payCodeBtn setTitle:@"付款码" forState:UIControlStateNormal];
    [payCodeBtn setImage:[UIImage imageNamed:@"home_付款码"] forState:UIControlStateNormal];
    [payCodeBtn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:payCodeBtn];
    self.payCodeBtn = payCodeBtn;
    
    YMCardButton *cardPackage = [[YMCardButton alloc]init];
    cardPackage.tag           = 2;
    [cardPackage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cardPackage setTitle:@"卡券包" forState:UIControlStateNormal];
    [cardPackage setImage:[UIImage imageNamed:@"home_卡券包"] forState:UIControlStateNormal];
    [cardPackage addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cardPackage];
    self.cardPackageBtn = cardPackage;
    YMCardButton *receiveCode = [[YMCardButton alloc]init];
    receiveCode.tag           = 3;
    [receiveCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [receiveCode setTitle:@"收款码" forState:UIControlStateNormal];
    [receiveCode setImage:[UIImage imageNamed:@"home_收款码"] forState:UIControlStateNormal];
    [receiveCode addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:receiveCode];
    self.receiveCodeBtn = receiveCode;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = SCREENWIDTH / 4;
    
    self.scanBtn.height = self.height;
    self.scanBtn.width  = width;
    self.scanBtn.x = self.scanBtn.y = 0;
    
    self.receiveCodeBtn.height=self.height;
    self.receiveCodeBtn.width=width;
    self.receiveCodeBtn.x=self.scanBtn.right;
    self.receiveCodeBtn.y=0;
    
    self.payCodeBtn.height = self.height;
    self.payCodeBtn.width  = width;
    self.payCodeBtn.x      = self.receiveCodeBtn.right;
    self.payCodeBtn.y      = 0;
    
    self.cardPackageBtn.height = self.height;
    self.cardPackageBtn.width  = width;
    self.cardPackageBtn.x      = self.payCodeBtn.right;
    self.cardPackageBtn.y      = 0;
}

-(void)btnDidClick:(UIButton *)btn
{
    if (self.clickItemBlock) {
        self.clickItemBlock(btn.tag);
    }
    if ([self.delegate respondsToSelector:@selector(topView:itemDidClick:)]) {
        [self.delegate topView:self itemDidClick:btn.tag];
    }
}

@end
