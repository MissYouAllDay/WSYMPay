//
//  YMPayPrepaidCardCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/16.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMPayPrepaidCardCell.h"

@interface YMPayPrepaidCardCell ()

@property (nonatomic, weak) UIImageView *youMingIcon;

@property (nonatomic, weak) UILabel *prepaidCardLabel;

@end

@implementation YMPayPrepaidCardCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
        [self setupSubviews];
    }
    
    return self;
}

-(void)setupSubviews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *youMingIcon = [[UIImageView alloc]init];
    youMingIcon.image        = [UIImage imageNamed:@"ymtcard"];
    [youMingIcon sizeToFit];
    [self.contentView addSubview:youMingIcon];
    self.youMingIcon = youMingIcon;
    
    UILabel *prepaidCardLabel  = [[UILabel alloc]init];
    prepaidCardLabel.text      = @"1111 **** **** 5641";
    prepaidCardLabel.font      = COMMON_FONT;
    prepaidCardLabel.textColor = FONTCOLOR;
    [self.contentView addSubview:prepaidCardLabel];
    self.prepaidCardLabel = prepaidCardLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.youMingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(LEFTSPACE);
        
    }];
    
    [self.prepaidCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.youMingIcon.mas_centerY);
        make.left.equalTo(self.youMingIcon.mas_right).offset(LEFTSPACE);
        
    }];
}

-(void)setPrepaidCardNO:(NSString *)prepaidCardNO
{
    _prepaidCardNO = [prepaidCardNO copy];
    
    NSString *headerStr = [_prepaidCardNO substringToIndex:4];
    NSString *footerStr = [_prepaidCardNO substringFromIndex:(_prepaidCardNO.length - 4)];
    
    self.prepaidCardLabel.text =[NSString stringWithFormat:@"%@ **** **** %@",headerStr,footerStr];
    [self.prepaidCardLabel sizeToFit];

}

@end
