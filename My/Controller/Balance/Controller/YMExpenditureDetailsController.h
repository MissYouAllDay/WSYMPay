//
//  YMExpenditureDetailsController.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/9.
//  Copyright © 2016年 赢联. All rights reserved.
//

/**
 我的--账户余额--收支明细--账单详情
 changed by pzj-2017/3/16
 */
#import "YMDetailsVC.h"

@class YMBillDetailsModel;

@interface YMExpenditureDetailsController : YMDetailsVC

@property (nonatomic, strong) YMBillDetailsModel *billDetails;

@end
