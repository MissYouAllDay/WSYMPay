//
//  YMMoneyView.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/7.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMMoneyView.h"

@interface YMMoneyView ()

@property (nonatomic, strong) UILabel *availableMoneyLabel;

@property (nonatomic, weak) UILabel *mainTitleLable;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@end


@implementation YMMoneyView

-(UILabel *)availableMoneyLabel
{
    if (!_availableMoneyLabel) {
        
        UILabel *availableMoneyLabel       = [[UILabel alloc]init];
        availableMoneyLabel.text          = @"可用余额(元)";
        availableMoneyLabel.font          = [UIFont systemFontOfSize:[VUtilsTool fontWithString:16]];
        availableMoneyLabel.textAlignment = NSTextAlignmentLeft;
        availableMoneyLabel.textColor     = FONTDARKCOLOR;
        [self addSubview:availableMoneyLabel];
        _availableMoneyLabel = availableMoneyLabel;
        
    }
    
    return _availableMoneyLabel;
}

-(UILabel*)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.font          = [UIFont systemFontOfSize:[VUtilsTool fontWithString:14]];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.textColor     = FONTDARKCOLOR;
        [self addSubview:_bottomLabel];
    }
    return _bottomLabel;
}

-(UILabel *)mainTitleLable
{
    if (!_mainTitleLable) {
        
        UILabel *mainTitleLable = [[UILabel alloc]init];
        mainTitleLable.text          = @"预付卡充值金额";
        mainTitleLable.font          = [UIFont systemFontOfSize:[VUtilsTool fontWithString:16]];
        mainTitleLable.textAlignment = NSTextAlignmentCenter;
        mainTitleLable.textColor     = FONTDARKCOLOR;
        [self addSubview:mainTitleLable];
        _mainTitleLable = mainTitleLable;
    }

    return _mainTitleLable;
}

-(UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        UILabel *moneyLabel = [[UILabel alloc]init];
        moneyLabel.text          = @"0.00";
        moneyLabel.font          = [UIFont systemFontOfSize:[VUtilsTool fontWithString:18]];
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.textColor     = FONTDARKCOLOR;
        [self addSubview:moneyLabel];
        _moneyLabel = moneyLabel;
    }
    
    return _moneyLabel;

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_bottomLabel) {
        CGFloat interval = (self.height - _mainTitleLable.height - _moneyLabel.height - _bottomLabel.height)/4;
        [_mainTitleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(interval);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [_moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(_mainTitleLable.mas_bottom).offset(interval);
        }];
        
        [_bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(_moneyLabel.mas_bottom).offset(interval);
        }];
        
    } else {
        [_availableMoneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height).multipliedBy(.2);
            make.width.equalTo(self.mas_width).multipliedBy(.35);
            make.top.mas_equalTo(LEFTSPACE);
            make.left.mas_equalTo(LEFTSPACE);
        }];
        
        [_mainTitleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(LEFTSPACE);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [_moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).multipliedBy(.75);
        }];
    }
}

-(void)setBottomTitle:(NSString *)bottomTitle
{
    _bottomTitle = [bottomTitle copy];
    self.bottomLabel.text = _bottomTitle;
    [self.bottomLabel sizeToFit];
}


-(void)setMoney:(NSString *)money
{
    _money = [money copy];
    self.moneyLabel.text = _money;
    [self.moneyLabel sizeToFit];
}

-(void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = [leftTitle copy];
    
    self.availableMoneyLabel.text = _leftTitle;

}

-(void)setMainTtitle:(NSString *)mainTtitle
{
    _mainTtitle = [mainTtitle copy];
    self.mainTitleLable.text = _mainTtitle;
    [self.mainTitleLable sizeToFit];

}
@end
