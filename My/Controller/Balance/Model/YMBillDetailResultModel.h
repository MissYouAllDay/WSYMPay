//
//  YMBillDetailResultModel.h
//  WSYMPay
//
//  Created by pzj on 2017/3/27.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 收支明细--详情--最终想要的model
 * 自己定义成想要的model,一个array中每条数据对应key-Vaule
 * 新修改的model
 */
#import <Foundation/Foundation.h>

@class YMReChargeDetailsModel;
@class YMCashDetailsModel;
@class YMPrepaidCardDetailsModel;

@interface YMBillDetailResultModel : NSObject

@property (nonatomic, copy) NSString *headTitle;
@property (nonatomic, copy) NSString *txAmt;//交易金额
@property (nonatomic, strong) NSMutableArray *keyValueArray;//充值详情
@property (nonatomic, strong) NSMutableArray *cashDetailkeyValueArray;//提现详情
@property (nonatomic, strong) NSMutableArray *prepaidDetailkeyValueArray;//预付费卡充值查询详情

/**
 充值详情查询
 
 @param model 充值详情查询model
 @return 最终想要的model
 */
+ (YMBillDetailResultModel *)getReChangeDetailsModelWithModel:(YMReChargeDetailsModel *)model;

/**
 提现详情查询

 @param model 提现详情model
 @return 最终想要的model
 */
+ (YMBillDetailResultModel *)getCashDetailsModelWithModel:(YMCashDetailsModel *)model;

/**
 预付费卡充值查询详情

 @param model 预付费卡充值查询详情model
 @return 最终想要的model
 */
+ (YMBillDetailResultModel *)getPrepaidCardDetailsModelWithModel:(YMPrepaidCardDetailsModel *)model;



- (NSString *)getHeadTitleStr;
- (NSString *)getTxAmtStr;

- (NSMutableArray *)getDataArray;
- (NSMutableArray *)getCashDataArray;
- (NSMutableArray *)getPrepaidDataArray;

- (NSInteger )getArrayCount;

@end
