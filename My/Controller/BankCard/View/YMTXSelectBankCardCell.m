//
//  YMTXSelectBankCardCell.m
//  WSYMPay
//
//  Created by pzj on 2017/7/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTXSelectBankCardCell.h"
#import "YMSelectModel.h"
#import "YMBankCardModel.h"

@implementation YMTXSelectBankCardCell


- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.textLabel.text = _titleStr;
    self.textLabel.font = COMMON_FONT;
    self.textLabel.textColor = FONTDARKCOLOR;
}
- (void)setBankCardModel:(YMBankCardModel *)bankCardModel
{
    _bankCardModel = bankCardModel;
    if (_bankCardModel == nil) {
        return;
    }
    self.textLabel.text = [_bankCardModel getBankStr];
    self.textLabel.font = COMMON_FONT;
    self.textLabel.textColor = FONTDARKCOLOR;
}
- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"payment_selected"]];
    }else{
        self.accessoryView = nil;
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
