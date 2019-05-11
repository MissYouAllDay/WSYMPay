//
//  YMTransferRecentRecodeDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 转账--查询最近转账记录model中 data的model
 */

/*
 * 转账到银行卡---限额说明model(bankName/lmitMaxAmt)用这两个字段
 */

#import <Foundation/Foundation.h>

@class YMTransferRecentRecodeDataListModel;

@interface YMTransferRecentRecodeDataModel : NSObject

@property (nonatomic, strong) NSMutableArray *list;

/**
 * 转账记录列表/转账到银行卡（限额说明）列表
 */
- (NSMutableArray *)getListArray;

- (NSInteger)getListArrayCount;

@end
