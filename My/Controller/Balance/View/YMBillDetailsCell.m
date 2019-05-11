//
//  YMBillDetailsCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/9.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMBillDetailsCell.h"
#import "UIView+Extension.h"
#import "YMBillDetailsModel.h"
@interface YMBillDetailsCell ()

@property (nonatomic, weak) UILabel *transactionNameLabel;

@property (nonatomic, weak) UILabel *transactionStatusLabel;

@property (nonatomic, weak) UILabel *transactionTimeLabel;

@property (nonatomic, weak) UILabel *moneyStatusLabel;

@property (nonatomic, weak) UILabel *banlanceLabel;

@property (nonatomic, weak) UILabel *yueLabel;

@end

@implementation YMBillDetailsCell

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
    
    UILabel *useLabel      = [[UILabel alloc]init];
    useLabel.font          = [UIFont systemFontOfMutableSize:16];
    useLabel.textColor     = FONTDARKCOLOR;
    useLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:useLabel];
    self.transactionNameLabel = useLabel;
    
    UILabel *usageStatus      = [[UILabel alloc]init];
    usageStatus.font          = [UIFont systemFontOfMutableSize:14];
    usageStatus.textColor     = FONTCOLOR;
    usageStatus.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:usageStatus];
    self.transactionStatusLabel = usageStatus;
    
    UILabel *timeLabel      = [[UILabel alloc]init];
    timeLabel.font          = [UIFont systemFontOfMutableSize:14];
    timeLabel.textColor     = FONTCOLOR;
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeLabel];
    self.transactionTimeLabel = timeLabel;
    
    UILabel *moneyStatusLabel      = [[UILabel alloc]init];
    moneyStatusLabel.font          = [UIFont systemFontOfMutableSize:16];
    moneyStatusLabel.textColor     = FONTDARKCOLOR;
    moneyStatusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:moneyStatusLabel];
    self.moneyStatusLabel = moneyStatusLabel;
    
    UILabel *banlanceLabel      = [[UILabel alloc]init];
    banlanceLabel.font          = [UIFont systemFontOfMutableSize:14];
    banlanceLabel.textColor     = FONTCOLOR;
    banlanceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:banlanceLabel];
    self.banlanceLabel = banlanceLabel;
    
    /*
     * 2017/3/15 产品要求去掉余额
     */
    UILabel *yueLabel = [[UILabel alloc]init];
    yueLabel.font          = [UIFont systemFontOfMutableSize:14];
    yueLabel.textColor     = FONTCOLOR;
    yueLabel.text          = @"余额:";
    yueLabel.textAlignment = NSTextAlignmentRight;
    [yueLabel sizeToFit];
//    [self.contentView addSubview:yueLabel];
//    self.yueLabel = yueLabel;
    
    
}

-(void)setBillDetails:(YMBillDetailsModel *)billDetails
{
    _billDetails = billDetails;
    
    self.transactionNameLabel.text   = [_billDetails getPrdNameStr];
    self.transactionStatusLabel.text = [_billDetails getOrdStatusNameStr];
    self.transactionTimeLabel.text   = [_billDetails getOrderDateStr];
    self.moneyStatusLabel.text       = [_billDetails getTxAmtStr];

    [self.transactionNameLabel sizeToFit];
    [self.transactionStatusLabel sizeToFit];
    [self.transactionTimeLabel sizeToFit];
    [self.moneyStatusLabel sizeToFit];
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat interval  = (self.contentView.height - self.transactionNameLabel.height - self.transactionStatusLabel.height) / 3;
    CGFloat leftspace = interval * 0.6;
    
    [self.transactionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(leftspace);
        make.top.equalTo(self.contentView.mas_top).offset(interval);
    }];
    
    [self.transactionStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(leftspace);
        make.top.equalTo(self.transactionNameLabel.mas_bottom).offset(interval);
    }];
    
    [self.transactionTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.transactionStatusLabel.mas_right).offset(5);
        make.bottom.equalTo(self.transactionStatusLabel.mas_bottom);
    }];
    
    [self.moneyStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-leftspace);
        make.top.equalTo(self.transactionNameLabel.mas_top);
    }];
    
    [self.banlanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.moneyStatusLabel.mas_right);
        make.bottom.equalTo(self.transactionTimeLabel.mas_bottom);
    }];
    
    [self.yueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.banlanceLabel.mas_left);
        make.bottom.equalTo(self.transactionTimeLabel.mas_bottom);
    }];

}


@end
