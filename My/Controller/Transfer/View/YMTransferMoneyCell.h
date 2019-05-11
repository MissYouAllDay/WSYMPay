//
//  YMTransferMoneyCell.h
//  WSYMPay
//
//  Created by pzj on 2017/5/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 有名钱包账户转账界面cell（转账金额）
 */
#import <UIKit/UIKit.h>

@protocol YMTransferMoneyCellDelegate <NSObject>

- (void)textFieldBeginEditing;
- (void)textFieldWithMoney:(NSString *)money;
- (void)textFieldWithBeiZhu:(NSString *)beiZhu;

@end

@interface YMTransferMoneyCell : UITableViewCell<YMTransferMoneyCellDelegate>
@property (nonatomic, strong) UITextField *moneyTextField;//转账钱

@property (nonatomic, weak)id<YMTransferMoneyCellDelegate>delegate;

@end
