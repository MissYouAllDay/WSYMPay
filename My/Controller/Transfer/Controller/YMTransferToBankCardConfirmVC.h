//
//  YMTransferToBankCardConfirmVC.h
//  WSYMPay
//
//  Created by pzj on 2017/5/3.
//  Copyright © 2017年 赢联. All rights reserved.
//


/**
 * 转到银行卡确认转账信息界面VC （转到银行卡界面点击确认转账按钮进入的界面）
 * 2017-5-25 pzj 新修改 转账到银行卡 code = 1时处理中，一个状态
 *（转到银行卡）
 */
#import <UIKit/UIKit.h>

@class YMTransferToBankSearchFeeDataModel;

@interface YMTransferToBankCardConfirmVC : UITableViewController

@property (nonatomic, strong) YMTransferToBankSearchFeeDataModel *searchFeeDataModel;

@end
