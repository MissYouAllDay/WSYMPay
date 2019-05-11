//
//  YMPayCashierTopCell.h
//  WSYMPay
//
//  Created by pzj on 2017/5/22.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 新的收银台 顶部 标题cell
 */
#import <UIKit/UIKit.h>

@class YMBankCardDataModel;

@protocol YMPayCashierTopCellDelegate <NSObject>

- (void)selectQuitBtnMethod;

@end

@interface YMPayCashierTopCell : UITableViewCell<YMPayCashierTopCellDelegate>

@property (nonatomic, strong) YMBankCardDataModel *bankCardDataModel;
@property (nonatomic, weak)id<YMPayCashierTopCellDelegate>delegate;

@end
