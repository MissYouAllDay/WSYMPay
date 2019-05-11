//
//  YMCollectionBaseListModel.h
//  WSYMPay
//
//  Created by pzj on 2017/8/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * app4期 我要收款model
 */
#import <Foundation/Foundation.h>

@interface YMCollectionBaseListModel : NSObject

@property (nonatomic, copy) NSString *orderMsg;//订单内容
@property (nonatomic, copy) NSString *orderNo;//订单号
@property (nonatomic, copy) NSString *tranType;//交易类型4转账
@property (nonatomic, copy) NSString *ordDate;
@property (nonatomic, copy) NSString *ordStatus;
@property (nonatomic, copy) NSString *ordTime;
@property (nonatomic, copy) NSString *txAmt;

- (NSString *)getOrderMsgStr;
- (NSString *)getOrderNoStr;
- (NSString *)getTranTypeStr;
- (NSString *)getOrdDateStr;
- (NSString *)getOrdStatusStr;
- (NSString *)getOrdTimeStr;
- (NSString *)getTxAmStr;
@end
