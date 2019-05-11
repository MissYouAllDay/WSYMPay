//
//  YMTransferCheckAccountModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//


/**
 * 转账到余额 (校验校验转入方账户、转出方余额限额信息) 总 Model
 */
#import <Foundation/Foundation.h>

@class YMTransferCheckAccountDataModel;

@interface YMTransferCheckAccountModel : NSObject

@property (nonatomic, copy)NSString *resCode;
@property (nonatomic, copy)NSString *resMsg;
@property (nonatomic, strong)YMTransferCheckAccountDataModel *data;

- (NSString *)getResMsgStr;
- (NSString *)getResCodeStr;
- (YMTransferCheckAccountDataModel *)getDtatModel;
@end
