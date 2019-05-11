//
//  YMMyPrepaidCardCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/2.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMMyPrepaidCardCell.h"
#import "UIView+Extension.h"
#import "YMPrepaidCardModel.h"
@interface YMMyPrepaidCardCell ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, weak) UILabel     *bankCardNoLabel;

@property (nonatomic, weak) UIButton    *managementButton;
@end

@implementation YMMyPrepaidCardCell
- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"prepaidcard_back"];
        [self.backgroundView addSubview:_bgImageView];
    }
    return _bgImageView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
        self.backgroundView = [[UIView alloc] init];
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = VIEWGRAYCOLOR;
        
//        self.backgroundView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"prepaidcard_back"]];
//        self.selectionStyle  = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = VIEWGRAYCOLOR;
      
        [self setupSubviews];
    }
    
    return self;
}

-(void)setupSubviews
{

    UILabel     *bankCardNoLabel = [[UILabel alloc]init];
    bankCardNoLabel.textColor       = [UIColor whiteColor];
    bankCardNoLabel.text            = @"1111  ****  ****  7896";
    bankCardNoLabel.font            = [UIFont systemFontOfSize:[VUtilsTool fontWithString:17]];
    [self.contentView addSubview:bankCardNoLabel];
    self.bankCardNoLabel = bankCardNoLabel;
    
    UIButton *managementButton = [[UIButton alloc]init];
    [managementButton setBackgroundImage:[UIImage imageNamed:@"manage"] forState:UIControlStateNormal];
    [managementButton setBackgroundImage:[UIImage imageNamed:@"manage_press"] forState:UIControlStateHighlighted];
    [managementButton addTarget:self action:@selector(managementButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:managementButton];
    [managementButton sizeToFit];
    self.managementButton = managementButton;

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.x      = LEFTSPACE;
    self.backgroundView.y      = 0;
    self.backgroundView.width  = self.width - (LEFTSPACE * 2);
    self.backgroundView.height = self.height;
    
    
    [self bgImageView].x = 0;
    [self bgImageView].y = HEADERSECTION_HEIGHT;
    [self bgImageView].width = self.width - (LEFTSPACE * 2);
    [self bgImageView].height = self.height-HEADERSECTION_HEIGHT;
    
    
    self.contentView.x      = LEFTSPACE;
    self.contentView.y      = 0;
    self.contentView.width  = self.width - (LEFTSPACE * 2);
    self.contentView.height = self.height;
    
    self.bankCardNoLabel.height = LEFTSPACE+5;
    self.bankCardNoLabel.x      = self.backgroundView.width * 0.1;
    self.bankCardNoLabel.y      = self.backgroundView.height - LEFTSPACE - self.bankCardNoLabel.height;
    
//    self.managementButton.y      = self.bankCardNoLabel.centerY - 10;
    self.managementButton.centerY = self.bankCardNoLabel.centerY;
    self.managementButton.x      = self.contentView.width - self.managementButton.width - LEFTSPACE;
    
}

-(void)setPrepaidCardNO:(YMPrepaidCardModel *)prepaidCardNO
{
    _prepaidCardNO = prepaidCardNO;
    if (_prepaidCardNO == nil) {
        return;
    }
    self.bankCardNoLabel.text = [self setShowFormatForPrepaidCard:_prepaidCardNO.prepaidNo];
    [self.bankCardNoLabel sizeToFit];
    [self setNeedsLayout];
}


-(void)managementButtonDidClick
{
    if ([self.delegate respondsToSelector:@selector(myPrepaidCardCellManagementButtonDidClick:)]) {
        [self.delegate myPrepaidCardCellManagementButtonDidClick:self];
    }
}

-(NSString *)setShowFormatForPrepaidCard:(NSString *)pNo;
{

    NSString *headStr = [pNo substringToIndex:4];
    NSString *footStr = [pNo substringFromIndex:12];
    
    return [NSString stringWithFormat:@"%@%@%@",headStr,@"  ****  ****  ",footStr];
}

@end
