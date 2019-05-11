//
//  YMTransferCheckPayPwdModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 转账到余额校验支付密码 总model
 */
/*
 * 转账到银行卡校验支付密码 总model
 */
#import <Foundation/Foundation.h>

@class YMTransferCheckPayPwdDataModel;

@interface YMTransferCheckPayPwdModel : NSObject

@property (nonatomic, copy)NSString *resCode;
@property (nonatomic, copy)NSString *resMsg;
@property (nonatomic, strong) YMTransferCheckPayPwdDataModel *data;


- (NSString *)getResMsgStr;
- (NSString *)getResCodeStr;
- (NSInteger)getResCodeNum;
- (YMTransferCheckPayPwdDataModel *)getDtatModel;

@end
