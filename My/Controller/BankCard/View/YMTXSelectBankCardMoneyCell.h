//
//  YMTXSelectBankCardMoneyCell.h
//  WSYMPay
//
//  Created by pzj on 2017/7/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * app4期新增
 * tx 输入金额 cell
 */

@protocol YMTXSelectBankCardMoneyCellDelegate <NSObject>

- (void)textFieldWithMoney:(NSString *)money;

@end

#import <UIKit/UIKit.h>

@interface YMTXSelectBankCardMoneyCell : UITableViewCell<YMTXSelectBankCardMoneyCellDelegate>

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (nonatomic, copy) NSString *moneyStr;
@property (nonatomic, weak) id<YMTXSelectBankCardMoneyCellDelegate>delegate;

@end
