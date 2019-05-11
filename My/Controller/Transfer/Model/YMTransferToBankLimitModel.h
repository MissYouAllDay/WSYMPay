//
//  YMTransferToBankLimitModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/11.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMTransferToBankLimitDataModel;

@interface YMTransferToBankLimitModel : NSObject

@property (nonatomic, copy) NSString *resCode;
@property (nonatomic, copy) NSString *resMsg;
@property (nonatomic, strong) YMTransferToBankLimitDataModel *data;

- (NSString *)getResCodeStr;
- (NSString *)getResMsgStr;
- (YMTransferToBankLimitDataModel *)getDataModel;

@end
