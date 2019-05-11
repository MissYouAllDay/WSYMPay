//
//  YMTransferDetailsCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/8.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferDetailsCell.h"
#import "YMTransferDetailsModel.h"
@interface YMTransferDetailsCell ()

@property (nonatomic, weak) UILabel *transactionStatusLabel;

@property (nonatomic, weak) UILabel *tratimeLabel;

@property (nonatomic, weak) UILabel *orderMsgLabel;

@property (nonatomic, weak) UILabel *txAmtLabel;

@property (nonatomic, weak) UILabel *weekNoLabel;



@end

@implementation YMTransferDetailsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubviews];
    }
    
    return self;
}

-(void)setupSubviews
{
    
    UILabel *tratimeLabel      = [[UILabel alloc]init];
    tratimeLabel.font          = [UIFont systemFontOfMutableSize:14];
    tratimeLabel.textColor     = FONTCOLOR;
    tratimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:tratimeLabel];
    self.tratimeLabel = tratimeLabel;
    
    UILabel *orderMsgLabel      = [[UILabel alloc]init];
    orderMsgLabel.font          = [UIFont systemFontOfMutableSize:11];
    orderMsgLabel.textColor     = FONTCOLOR;
    orderMsgLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:orderMsgLabel];
    self.orderMsgLabel = orderMsgLabel;
    
    UILabel *txAmtLabel      = [[UILabel alloc]init];
    txAmtLabel.font          = [UIFont systemFontOfMutableSize:15];
    txAmtLabel.textColor     = FONTDARKCOLOR;
    txAmtLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:txAmtLabel];
    self.txAmtLabel = txAmtLabel;
    
    UILabel *weekNoLabel      = [[UILabel alloc]init];
    weekNoLabel.font          = [UIFont systemFontOfMutableSize:13];
    weekNoLabel.textColor     = FONTCOLOR;
    weekNoLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:weekNoLabel];
    self.weekNoLabel = weekNoLabel;
    
}

-(UILabel *)transactionStatusLabel
{
    if (!_transactionStatusLabel) {
        UILabel *transactionStatusLabel      = [[UILabel alloc]init];
        transactionStatusLabel.font          = [UIFont systemFontOfMutableSize:13];
        transactionStatusLabel.textColor     = FONTDARKCOLOR;
        transactionStatusLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:transactionStatusLabel];
        _transactionStatusLabel = transactionStatusLabel;
    }
    return _transactionStatusLabel;
}

-(void)setDetails:(YMTransferDetailsModel *)details
{
    
    _details = details;
    
    
    NSString *tratime = [[details.tratime substringToIndex:10] substringFromIndex:5];
    
    self.tratimeLabel.text  = tratime;
    self.orderMsgLabel.text = details.orderMsg;
    self.txAmtLabel.text    = details.txAmt;
    self.weekNoLabel.text   = details.weekNo;
    
    
    NSString *ordStatus = @"";
    if (![details.ordStatus isString:@"01"]) {
        if ([details.ordStatus isString:@"00"]) {
            self.transactionStatusLabel.textColor = [UIColor redColor];
        } else {
            self.transactionStatusLabel.textColor = FONTDARKCOLOR;
        }
        ordStatus = [details getOrdStatus];
    }
    
    self.transactionStatusLabel.text = ordStatus;
    
    [self setNeedsLayout];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.tratimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFTSPACE);
        make.bottom.equalTo(self).offset(-LEFTSPACE);
    }];

    [self.orderMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-LEFTSPACE);
        make.bottom.equalTo(self.tratimeLabel);
    }];

    [self.txAmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderMsgLabel);
        make.top.equalTo(self).offset(LEFTSPACE);
    }];
    
    [self.weekNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txAmtLabel);
        make.left.equalTo(self.tratimeLabel);
        
    }];
    
    [_transactionStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tratimeLabel.mas_right).offset(LEFTSPACE);
        make.centerY.equalTo(self);
    }];

}

@end
