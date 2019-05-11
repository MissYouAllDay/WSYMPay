//
//  YMBankCardCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/11/29.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMSquaresButtonCell.h"
#import "UIView+Extension.h"
#import "YMCardButton.h"
@interface YMSquaresButtonCell ()

@property (nonatomic, weak) YMCardButton *scanButton;

@property (nonatomic, weak) YMCardButton *prepaidCardButton;

@property (nonatomic, weak) YMCardButton *bankCardButton;
@end


@implementation YMSquaresButtonCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupSubViews];
    }
    
    return self;
}

-(void)setupSubViews
{
    YMCardButton *scanButton = [[YMCardButton alloc]init];
    [scanButton setTitle:@"扫一扫" forState:UIControlStateNormal];
    [scanButton setImage:[UIImage imageNamed:@"扫一扫"] forState:UIControlStateNormal];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"mineback"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:scanButton];
    self.scanButton = scanButton;
    
    YMCardButton *prepaidCardButton = [[YMCardButton alloc]init];
    [prepaidCardButton setTitle:@"预付卡" forState:UIControlStateNormal];
    [prepaidCardButton setImage:[UIImage imageNamed:@"预付卡"] forState:UIControlStateNormal];
    [prepaidCardButton setBackgroundImage:[UIImage imageNamed:@"mineback"] forState:UIControlStateNormal];
    [prepaidCardButton addTarget:self action:@selector(prepaidCardButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:prepaidCardButton];
    self.prepaidCardButton = prepaidCardButton;
    
    YMCardButton *bankCardButton = [[YMCardButton alloc]init];
    [bankCardButton setTitle:@"银行卡" forState:UIControlStateNormal];
    [bankCardButton setBackgroundImage:[UIImage imageNamed:@"mineback"] forState:UIControlStateNormal];
    [bankCardButton setImage:[UIImage imageNamed:@"银行卡"] forState:UIControlStateNormal];
    [bankCardButton addTarget:self action:@selector(bankCardButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:bankCardButton];
    self.bankCardButton = bankCardButton;

}

-(void)scanButtonDidClick
{
    if ([self.delegate respondsToSelector:@selector(bankCardCellScanButtonDidClick:)]) {
        [self.delegate bankCardCellScanButtonDidClick:self];
    }
}

-(void)prepaidCardButtonDidClick
{
    
    if ([self.delegate respondsToSelector:@selector(bankCardCellPrepaidCardButtonDidClick:)]) {
        
        [self.delegate bankCardCellPrepaidCardButtonDidClick:self];
    }
    

}

-(void)bankCardButtonDidClick
{
    if ([self.delegate respondsToSelector:@selector(bankCardCellBankCardButtonDidClick:)]) {
        
        [self.delegate bankCardCellBankCardButtonDidClick:self];
    }

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = self.contentView.width / 3;
    CGFloat btnH = self.contentView.height;
    
    self.scanButton.x = self.scanButton.y = 0;
    self.scanButton.width  = btnW;
    self.scanButton.height = btnH;
    
    self.prepaidCardButton.x = btnW;
    self.prepaidCardButton.y = 0;
    self.prepaidCardButton.width  = btnW;
    self.prepaidCardButton.height = btnH;
    
    self.bankCardButton.x = btnW * 2;
    self.bankCardButton.y = 0;
    self.bankCardButton.width  = btnW;
    self.bankCardButton.height = btnH;
   
    
}

@end
