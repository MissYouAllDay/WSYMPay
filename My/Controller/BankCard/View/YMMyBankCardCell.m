//
//  YMBankCardCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/11/30.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMMyBankCardCell.h"
#import "UIView+Extension.h"
#import "YMBankCardModel.h"
#import <UIImageView+WebCache.h>
#import "UIColor+Extension.h"
@interface YMMyBankCardCell ()

@property (nonatomic, weak) UIImageView *bankIconImageView;
@property (nonatomic, weak) UILabel     *bankNameLabel;
@property (nonatomic, weak) UILabel     *bankTypeLabel;
@property (nonatomic, weak) UIImageView *quickPaymentIcon;
@property (nonatomic, weak) UILabel     *bankCardNoLabel;
@property (nonatomic, weak) UIButton    *managementButton;
@property (nonatomic, weak) UIView      *logoView;

@end

@implementation YMMyBankCardCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor     = RGBColor(17,130, 107);
        self.contentView.layer.cornerRadius  = CORNERRADIUS;
        self.contentView.layer.masksToBounds = YES;
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = VIEWGRAYCOLOR;
        
        [self setupSubviews];
    }
    
    return self;
}

-(void)setupSubviews
{
    
    UIView *logoView = [[UIView alloc]init];
    logoView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:logoView];
    self.logoView = logoView;
    
    UIImageView *bankIconImageView = [[UIImageView alloc]init];
    bankIconImageView.image = [UIImage imageNamed:@"ABC#00947e"];
    [self.contentView addSubview:bankIconImageView];
    [bankIconImageView sizeToFit];
    logoView.size = CGSizeMake(bankIconImageView.width + 2, bankIconImageView.height + 2);
    logoView.layer.cornerRadius = logoView.height * 0.5;
    self.bankIconImageView = bankIconImageView;
    
    UILabel     *bankNameLabel = [[UILabel alloc]init];
    bankNameLabel.text      = @"中国农业银行";
    bankNameLabel.font      = [UIFont systemFontOfSize:[VUtilsTool fontWithString:15]weight:UIFontWeightMedium];
    bankNameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:bankNameLabel];
    self.bankNameLabel = bankNameLabel;
    
     UILabel     *bankTypeLabel = [[UILabel alloc]init];
    bankTypeLabel.textColor     = [UIColor whiteColor];
    bankTypeLabel.text          = @"信用卡";
    bankTypeLabel.font          = [UIFont systemFontOfSize:[VUtilsTool fontWithString:13]weight:UIFontWeightMedium];
    [self.contentView addSubview:bankTypeLabel];
    self.bankTypeLabel = bankTypeLabel;
    
     UIImageView *quickPaymentIcon = [[UIImageView alloc]init];
    quickPaymentIcon.image         = [UIImage imageNamed:@"quickpayment"];
    [quickPaymentIcon sizeToFit];
    [self.contentView addSubview:quickPaymentIcon];
    
    self.quickPaymentIcon = quickPaymentIcon;
    
     UILabel     *bankCardNoLabel = [[UILabel alloc]init];
    bankCardNoLabel.textColor       = [UIColor whiteColor];
    bankCardNoLabel.text            = @"**** **** **** 7896";
    bankCardNoLabel.font            = [UIFont systemFontOfMutableSize:17];
    [self.contentView addSubview:bankCardNoLabel];
    self.bankCardNoLabel = bankCardNoLabel;
    
     UIButton *managementButton = [[UIButton alloc]init];
    [managementButton setBackgroundImage:[UIImage imageNamed:@"manage"] forState:UIControlStateNormal];
    [managementButton setBackgroundImage:[UIImage imageNamed:@"manage_press"] forState:UIControlStateHighlighted];
    [managementButton addTarget:self action:@selector(managementButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [managementButton sizeToFit];
    [self.contentView addSubview:managementButton];
    self.managementButton = managementButton;
    

}

-(void)managementButtonDidClick
{
    
    if ([self.delegate respondsToSelector:@selector(myBankCardCellManagementButtonDidClick:)]) {
        
        [self.delegate myBankCardCellManagementButtonDidClick:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.x      = LEFTSPACE;
    self.contentView.y      = 0;
    self.contentView.width  = self.width - (LEFTSPACE * 2);
    self.contentView.height = self.height;
    
    CGFloat interval = (self.contentView.height - LEFTSPACE * 3) /4;
    
    
    self.bankIconImageView.x      = interval;
    self.bankIconImageView.y      = interval;
    
    self.logoView.center = self.bankIconImageView.center;
    
    self.quickPaymentIcon.y       = interval;
    self.quickPaymentIcon.x       = self.contentView.width - interval - self.quickPaymentIcon.width;

    self.bankNameLabel.x      = self.bankIconImageView.right + interval;
    self.bankNameLabel.y      = interval;
    self.bankNameLabel.width  = self.contentView.width - self.bankNameLabel.x - interval * 2 - self.quickPaymentIcon.width;
    self.bankNameLabel.height = LEFTSPACE;
    
    self.bankTypeLabel.x      = self.bankNameLabel.x;
    self.bankTypeLabel.y      = self.bankNameLabel.bottom + interval / 2;
    self.bankTypeLabel.width  = self.bankNameLabel.width / 2;
    self.bankTypeLabel.height = LEFTSPACE;
    
    self.bankCardNoLabel.x      = self.bankTypeLabel.x;
    self.bankCardNoLabel.width  = self.contentView.width - self.bankCardNoLabel.x - self.quickPaymentIcon.width - LEFTSPACE * 2;
    self.bankCardNoLabel.height = LEFTSPACE;
    self.bankCardNoLabel.y      =self.bankTypeLabel.bottom + interval * 1.5;

    self.managementButton.centerY = self.bankCardNoLabel.centerY;
    self.managementButton.x       = self.quickPaymentIcon.x;
    
}


-(void)setBankCardInfo:(YMBankCardModel *)bankCardInfo
{
        
    _bankCardInfo = bankCardInfo;
    self.contentView.backgroundColor = [UIColor colorWithHexString:bankCardInfo.backgroudColor];
    NSString *bankIcon = [NSString stringWithFormat:@"%@%@",IP,_bankCardInfo.logoPic];
    
    [self.bankIconImageView sd_setImageWithURL:[NSURL URLWithString:bankIcon]];
    self.bankTypeLabel.text = _bankCardInfo.bankCardType;
    self.bankNameLabel.text = _bankCardInfo.bankName;
    if (_bankCardInfo.bankAcNo.length) {
        NSString *str = _bankCardInfo.bankAcNo;
        YMLog(@"str = %@ ,paySign = %@",str,_bankCardInfo.paySign);
        self.bankCardNoLabel.text  = [NSString stringWithFormat:@"**** **** **** %@",str];
    }

}
@end
