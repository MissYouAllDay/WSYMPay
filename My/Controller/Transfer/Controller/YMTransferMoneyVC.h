//
//  YMTransferMoneyVC.h
//  WSYMPay
//
//  Created by pzj on 2017/5/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 有名钱包账户转账  界面vc（转账金额）
 *（转到有名钱包账户）
 */
#import <UIKit/UIKit.h>

@class YMTransferCheckAccountDataModel;

@interface YMTransferMoneyVC : UITableViewController
@property (nonatomic, copy) NSString *moneyStr;
@property (nonatomic, copy) NSString *functionSource;//功能来源 1 普通转账 2 收款码
@property (nonatomic, copy) NSString *paymentDate;//0：实时到账 1：次日到账

@property (nonatomic, strong)YMTransferCheckAccountDataModel *dataModel;

@end
