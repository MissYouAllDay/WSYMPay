//
//  YMAllBillDetailVC.h
//  WSYMPay
//
//  Created by pzj on 2017/7/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 账单详情界面vc
 ********************************************
 * 样式1、（付款方式、商品信息）（创建时间、商品订单号、支付流水号）订单投诉
 * 样式1、（付款方式、商品信息）（创建时间、商品订单号、支付流水号）(投诉状态、投诉原因、投诉处理说明)撤销投诉/确认/没有按钮
 
 * 样式1、扫一扫超级收款码：---- 属于消费
        （付款方式、商品信息）（创建时间、商品订单号、支付流水号）
 * 扫一扫pc端生成的二维码：
        （付款方式、商品信息）（创建时间、商品订单号、支付流水号）
 * tx:
        （付款方式、商品信息）（创建时间、商品订单号、支付流水号）
 ********************************************
 * 样式2、我要收款：
          (付款方式、转账说明、对方账户）(创建时间、支付流水号)
 * 扫一扫有名收款码：
          用样式2

 ********************************************
 * 样式3、手机话费充值：----消费中手机充值
         (付款方式、充值说明、充值号码、面值、交易对象)(创建时间、商品订单号、支付流水号)
         支付成功时---订单投诉/超时---无按钮/未支付时---立即支付
 ********************************************
 */


typedef NS_ENUM(NSInteger, BillDetailType) {
    BillDetailConsumeMobilePhoneRecharge         = 0,//消费---手机话费充值
    BillDetailConsumeScan                        = 1,//消费---扫一扫超级收款码
    BillDetailPCScan                             = 1,//扫一扫pc端生成的二维码
    BillDetailTX                                 = 1,//TX
    BillDetailAccountTransfer                    = 2,//转账(我要收款/ 扫一扫有名收款码)
    BillDetailAccountRecharge                    = 3,//账户充值
    BillDetailAccountWithDrawal                  = 4,//账户提现
    
    

};

#import <UIKit/UIKit.h>

@class YMAllBillListDataListModel;

@interface YMAllBillDetailVC : UIViewController

@property (assign,nonatomic,readwrite) BillDetailType billDetailType;
@property (nonatomic, strong) YMAllBillListDataListModel *billListModel;
@property (nonatomic) BOOL hiddenFooterView;
//tranType 交易类型(对应详情分类)（1消费2手机充值3充值4转账5提现）
- (void) sendOrderNo:(NSString *)orderNo tranType:(NSString *)tranType;

@end
