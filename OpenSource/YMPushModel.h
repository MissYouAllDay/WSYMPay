//
//  YMPushModel.h
//  WSYMMerchantPay
//
//  Created by W-Duxin on 2017/6/28.
//  Copyright © 2017年 WSYM. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 用于接收推送的信息*/
@interface YMPushModel : NSObject
/**
 订单号
 */
@property (nonatomic, copy) NSString *pushPrdOrdNo;
/**
 订单类型 1聚合收款 2 银联收款 3 扫一扫
 */
@property (nonatomic, copy) NSString *pushTranType;
/**
 消息内容
 */
@property (nonatomic, copy) NSString *alert;


/**
 显示订单详情页面 默认全部显示 银联 扫一扫 聚合
 */
-(void)showBillDetailsVC;
/**
 显示银联订单详情
 */
-(void)showBillDetailsVCWithCUP;
@end
