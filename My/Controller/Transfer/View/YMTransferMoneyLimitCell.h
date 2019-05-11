//
//  YMTransferMoneyLimitCell.h
//  WSYMPay
//
//  Created by pzj on 2017/5/3.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 限额说明界面cell (转账到银行卡的限额说明页)
 */
#import <UIKit/UIKit.h>

@class YMTransferRecentRecodeDataListModel;

@interface YMTransferMoneyLimitCell : UITableViewCell

@property (nonatomic, strong) YMTransferRecentRecodeDataListModel *listModel;

@end
