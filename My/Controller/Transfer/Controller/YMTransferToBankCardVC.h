//
//  YMTransferToBankCardVC.h
//  WSYMPay
//
//  Created by pzj on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//


/**
 * 转到银行卡界面vc（转账界面 点击转到银行卡cell 进入的界面）
 */
#import <UIKit/UIKit.h>

@class YMTransferRecentRecodeDataListModel;

@interface YMTransferToBankCardVC : UITableViewController

@property (nonatomic, strong) YMTransferRecentRecodeDataListModel *dataListModel;//上个界面返回的最近转账信息model

@end
