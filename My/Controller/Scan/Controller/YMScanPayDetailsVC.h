//
//  YMOrderDetailsVC.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 扫PC段二维码，进入的订单信息界面
 * 展示订单信息
 * 点击确认支付，调起支付收银台
 * 2017-7-19 changed by pzj
 */
#import "YMDetailsVC.h"
@class YMScanModel;
@interface YMScanPayDetailsVC : YMDetailsVC
@property (nonatomic, strong) YMScanModel *details;
@end
