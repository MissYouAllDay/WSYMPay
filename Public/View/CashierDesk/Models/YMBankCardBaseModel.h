//
//  YMPrepaidCardBaseModel.h
//  WSYMPay
//
//  Created by pzj on 2017/3/21.
//  Copyright © 2017年 赢联. All rights reserved.
//


/*
 * 预付充值卡/ 银行卡相关  base model
 */
#import <Foundation/Foundation.h>

@class YMBankCardDataModel;

@interface YMBankCardBaseModel : NSObject

@property (nonatomic, assign) NSInteger resCode;//返回状态码
@property (nonatomic, copy) NSString *resMsg;//返回信息
@property (nonatomic, strong) YMBankCardDataModel *data;//数据

- (YMBankCardDataModel *)getBankCardDataModel;
- (NSInteger )getResCodeNum;
- (NSString *)getResMsgStr;

@end
