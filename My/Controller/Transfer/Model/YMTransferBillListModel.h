//
//  YMTransferBillListModel.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMTransferBillListModel : NSObject

@property (nonatomic, copy) NSString *tratime;	//转账申请时间
@property (nonatomic, copy) NSString *toAccName;	//接收方用户名
@property (nonatomic, copy) NSString *txAmt;	//转账金额
@property (nonatomic, copy) NSString *weekNo;	//星期
@property (nonatomic, copy) NSString *ordStatus;	//订单状态
@property (nonatomic, copy) NSString *tragetno;	//对方账户
@property (nonatomic, copy) NSString *orderMsg;	//订单信息
@property (nonatomic, copy) NSString *tratype;	//	转账说明
@property (nonatomic, copy) NSString *traordno;	//	转账订单
@property (nonatomic, copy) NSString *paymentMethod; //	付款方式

@end
