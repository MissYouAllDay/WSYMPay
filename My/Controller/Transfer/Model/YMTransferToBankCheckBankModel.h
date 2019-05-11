//
//  YMTransferToBankCheckBankModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/9.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 转账到银行卡--验证银行卡Model(总model)
 */
#import <Foundation/Foundation.h>

@class YMTransferToBankCheckBankDataModel;

@interface YMTransferToBankCheckBankModel : NSObject

@property (nonatomic, copy)NSString *resCode;
@property (nonatomic, copy)NSString *resMsg;
@property (nonatomic, strong) YMTransferToBankCheckBankDataModel *data;

- (NSString *)getResMsgStr;
- (NSString *)getResCodeStr;
- (YMTransferToBankCheckBankDataModel *)getDtatModel;

@end
