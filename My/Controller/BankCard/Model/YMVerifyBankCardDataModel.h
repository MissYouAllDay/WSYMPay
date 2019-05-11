//
//  YMVerifyBankCardDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/7/31.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 信用卡安全码存数据库model
 */
#import "YMBaseDB.h"

@interface YMVerifyBankCardDataModel : YMBaseDB

@property (nonatomic, copy) NSString *paySingKey;//key
@property (nonatomic, copy) NSString *safetyCode;//安全码

#pragma mark - 数据库相关
/**
 删除所有表
 */
+ (void)deletAllDBTable;

#pragma mark - 取值

- (NSString *)getSafetyCodeStr;



@end
