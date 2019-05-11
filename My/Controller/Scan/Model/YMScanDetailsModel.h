//
//  YMScanDetailsModel.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/10.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMScanDetailsModel : NSObject

@property (nonatomic, copy) NSString *orderTime;  	//订单时间
@property (nonatomic, copy) NSString *orderType;  	//订单类型
@property (nonatomic, copy) NSString *payType;  	//支付类型
@property (nonatomic, copy) NSString *ordStatus;  	//订单状态
@property (nonatomic, copy) NSString *txAmt;        //支付金额
@property (nonatomic, copy) NSString *merName;  	//商户名称
@property (nonatomic, copy) NSString *prdName;  	//订单名称
@property (nonatomic, copy) NSString *prdOrdNo;  	//订单号
@property (nonatomic, copy) NSString *payOrdNo;  	//支付流水号
@property (nonatomic, copy) NSString *merNo;        //商户号

@end
