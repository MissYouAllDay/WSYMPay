//
//  YMPayBalanceCell.h
//  WSYMPay
//
//  Created by pzj on 2017/5/24.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 选择支付方式---余额cell
 */
#import <UIKit/UIKit.h>

@class YMBankCardDataModel;

@interface YMPayBalanceCell : UITableViewCell

- (void)sendBankCardDataModel:(YMBankCardDataModel *)model isSelect:(BOOL)isSelect;

@end
