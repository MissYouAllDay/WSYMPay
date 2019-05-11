//
//  YMFinancialClassCell.m
//  WSYMPay
//
//  Created by pzj on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMFinancialClassCell.h"

@implementation YMFinancialClassCell

- (void)setClassImageStr:(NSString *)classImageStr
{
    _classImageStr = classImageStr;
    _classImage.image = [UIImage imageNamed:_classImageStr];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
