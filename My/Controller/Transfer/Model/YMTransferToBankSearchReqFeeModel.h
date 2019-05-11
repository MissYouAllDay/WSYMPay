//
//  YMTransferToBankSearchReqFeeModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/9.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 转账到银行卡 --- 查询转账手续费Model
 */
#import <Foundation/Foundation.h>

@class YMTransferToBankSearchFeeDataModel;

@interface YMTransferToBankSearchReqFeeModel : NSObject

@property (nonatomic, copy)NSString *resCode;
@property (nonatomic, copy)NSString *resMsg;
@property (nonatomic, strong) YMTransferToBankSearchFeeDataModel *data;

- (NSString *)getResMsgStr;
- (NSString *)getResCodeStr;
- (YMTransferToBankSearchFeeDataModel *)getDtatModel;

@end
