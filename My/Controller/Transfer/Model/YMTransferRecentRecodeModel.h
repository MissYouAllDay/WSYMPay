//
//  YMTransferRecentRecodeModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 转账--查询最近转账记录model
 */

/*
 * 转账到银行卡---限额说明model(bankName/lmitMaxAmt)用这两个字段
 */

#import <Foundation/Foundation.h>

@class YMTransferRecentRecodeDataModel;

@interface YMTransferRecentRecodeModel : NSObject

@property (nonatomic, copy)NSString *resCode;
@property (nonatomic, copy)NSString *resMsg;
@property (nonatomic, strong) YMTransferRecentRecodeDataModel *data;

- (NSString *)getResMsgStr;
- (NSString *)getResCodeStr;
- (YMTransferRecentRecodeDataModel *)getDataModel;

@end
