//
//  YMPayBankCardCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMPayBankCardCell.h"
#import "YMBankCardModel.h"
#import <UIImageView+WebCache.h>
#import "YMUserInfoTool.h"
#import "YMBankCardDataModel.h"

CGFloat interval = LEFTSPACE * 0.8;

@interface YMPayBankCardCell ()

@property (nonatomic, weak) UIImageView *bankIconImageView;

@property (nonatomic, weak) UILabel *bankNameLabel;

//@property (nonatomic, weak) UILabel *tailNumberLabel;

@property (nonatomic, weak) UILabel *enabledLabel;

@property (nonatomic, weak) UIView  *enableBgView;

@property (nonatomic, strong) UILabel *userTypeLabel;

@end

@implementation YMPayBankCardCell

-(UILabel *)enabledLabel
{
    if (!_enabledLabel) {
        
        UILabel *enabledLabel      = [[UILabel alloc]init];
        enabledLabel.text          = @"当前交易不支持该支付方式";
        enabledLabel.textColor     = FONTDARKCOLOR;
        enabledLabel.textAlignment = NSTextAlignmentLeft;
        enabledLabel.font          = [UIFont systemFontOfMutableSize:13];
        [enabledLabel sizeToFit];
        [self.contentView addSubview:enabledLabel];
        self.enabledLabel = enabledLabel;
    }
    
    return _enabledLabel;
}


-(UIView *)enableBgView
{
    if (!_enableBgView) {
        
        UIView *enableBgView = [[UIView alloc]init];
        enableBgView.backgroundColor = [UIColor whiteColor];
        enableBgView.alpha = 0.5;
        enableBgView.userInteractionEnabled = NO;
        [self.contentView addSubview:enableBgView];
        _enableBgView = enableBgView;
    }
    
    return _enableBgView;
}
- (UILabel *)userTypeLabel
{
    if (!_userTypeLabel) {
        _userTypeLabel = [[UILabel alloc] init];
        _userTypeLabel.text = @"    请选择支付方式";
        _userTypeLabel.textColor = FONTCOLOR;
        _userTypeLabel.font = COMMON_FONT;
    }
    return _userTypeLabel;
}

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
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    UIImageView *bankIconImageView = [[UIImageView alloc]init];
    bankIconImageView.image = [UIImage imageNamed:@""];
    [bankIconImageView sizeToFit];
    [self.contentView addSubview:bankIconImageView];
    self.bankIconImageView = bankIconImageView;
    
    UILabel *bankNameLabel  = [[UILabel alloc]init];
    bankNameLabel.text      = @"";
    bankNameLabel.font      = COMMON_FONT;
    bankNameLabel.textColor = FONTDARKCOLOR;
    [bankNameLabel sizeToFit];
    [self.contentView addSubview:bankNameLabel];
    self.bankNameLabel = bankNameLabel;
    
}
- (void)setType:(NSInteger)type
{
    _type = type;
    
}
-(void)setBankCardModel:(YMBankCardModel *)bankCardModel
{
    _bankCardModel = bankCardModel;
    if (_bankCardModel == nil) {
        return;
    }
    
    if (_bankCardModel.userTypeNum == 9) {//请选择支付方式时显示（充值情况）
        
        [self.contentView addSubview:self.userTypeLabel];
        self.userTypeLabel.hidden = NO;
        [self.userTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 100));
        }];
        
    }else{
        self.userTypeLabel.hidden = YES;
        if (self.type == 2) {//提现
            if ([_bankCardModel getCardTypeCount] == 1 ) {
                if (_isSelected) {
                    self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"payment_selected"]];
                }else{
                    self.accessoryView = nil;
                }
            }else{
                self.accessoryView = nil;
            }
            
            //银行卡名称及卡号
            self.bankNameLabel.text = [_bankCardModel getBankStr];
            [ImageViewTool setImage:self.bankIconImageView imageUrl:[_bankCardModel getLogoPicStr]];
            
            [self.bankIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(interval);
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.width.mas_equalTo(71/2);
                make.height.mas_equalTo(71/2);
            }];
            
            if ([_bankCardModel getCardTypeCount] == 1) {
                [self.bankNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.bankIconImageView.mas_right).offset((interval * 0.5)+5);
                    make.centerY.equalTo(self.bankIconImageView.mas_centerY);
                }];
                
                _enableBgView.hidden = YES;
                _enabledLabel.hidden = YES;
            } else {
                _enableBgView.hidden = NO;
                _enabledLabel.hidden = NO;
                [self.bankNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.bankIconImageView.mas_centerY).offset(-2);
                    make.left.equalTo(self.bankIconImageView.mas_right).offset((interval * 0.5)+5);
                }];
                [self.enabledLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.bankNameLabel.mas_left);
                    make.top.equalTo(self.bankNameLabel.mas_bottom).offset(2);
                }];
                [self.enableBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView.mas_left);
                    make.right.equalTo(self.contentView.mas_right);
                    make.top.equalTo(self.contentView.mas_top);
                    make.bottom.equalTo(self.contentView.mas_bottom);
                }];
            }
        }else{
            
            if ([_bankCardModel isCanUseFlag]) {
                if (_isSelected) {
                    self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"payment_selected"]];
                }else{
                    self.accessoryView = nil;
                }
            }else{
                self.accessoryView = nil;
            }
            //银行卡名称及卡号
            self.bankNameLabel.text      =[_bankCardModel getBankStr];
            [ImageViewTool setImage:self.bankIconImageView imageUrl:[_bankCardModel getLogoPicStr]];
            
            [self.bankIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(interval);
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.width.mas_equalTo(71/2);
                make.height.mas_equalTo(71/2);
            }];
            
            if ([_bankCardModel isCanUseFlag]) {
                [self.bankNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.bankIconImageView.mas_right).offset((interval * 0.5)+5);
                    make.centerY.equalTo(self.bankIconImageView.mas_centerY);
                }];
                _enableBgView.hidden = YES;
                _enabledLabel.hidden = YES;
            }else{
                _enableBgView.hidden = NO;
                _enabledLabel.hidden = NO;
                [self.bankNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.bankIconImageView.mas_centerY).offset(-2);
                    make.left.equalTo(self.bankIconImageView.mas_right).offset((interval * 0.5)+5);
                }];
                [self.enabledLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.bankNameLabel.mas_left);
                    make.top.equalTo(self.bankNameLabel.mas_bottom).offset(2);
                }];
                [self.enableBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView.mas_left);
                    make.right.equalTo(self.contentView.mas_right);
                    make.top.equalTo(self.contentView.mas_top);
                    make.bottom.equalTo(self.contentView.mas_bottom);
                }];
            }
            
        }

    }
    
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
}

- (void)sendSelectYuEWithBankCardDataModel:(YMBankCardDataModel*)dataModel yuEIsSelected:(BOOL)yuEIsSelected
{
    if (yuEIsSelected) {
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"payment_selected"]];
    }else{
        self.accessoryView = nil;
    }
    //余额
    YMUserInfoTool *currentUserInfo = [YMUserInfoTool shareInstance];
    self.bankNameLabel.text      = [NSString stringWithFormat:@"余额%@元",[currentUserInfo getCashAcBalStr]];
    self.bankIconImageView.image = [UIImage imageNamed:@"balanceImg"];
    
    [self.bankIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(interval);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(71/2);
        make.height.mas_equalTo(71/2);
    }];
    [self.bankNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankIconImageView.mas_right).offset((interval * 0.5)+5);
        make.centerY.equalTo(self.bankIconImageView.mas_centerY);
    }];
    
    self.enabledLabel.hidden = YES;
    
    if ([dataModel isAcbalUsed]) {//余额可选
        self.enableBgView.hidden = YES;
    }else{//余额不可选
        self.enableBgView.hidden = NO;
    }
    [self.enableBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

@end
