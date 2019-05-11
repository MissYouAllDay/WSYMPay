//
//  YMTransferSuccessVC.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 转账成功界面
 */
#import "YMResultVC.h"

@class YMTransferCheckPayPwdDataModel;

@interface YMTransferSuccessVC : YMResultVC
@property (nonatomic, copy) NSString *transferMoney;

@property (nonatomic, strong) YMTransferCheckPayPwdDataModel *dataModel;

@property (nonatomic, copy) NSString *orderNo;

@end
