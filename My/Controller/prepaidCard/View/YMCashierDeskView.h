//
//  YMCashierDeskView.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/18.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 充值选择支付方式view弹框
 * 支付详情 view
 * changed  2017-3-21
 */
#import <UIKit/UIKit.h>

@class YMCashierDeskView;
@protocol YMCashierDeskViewdelegate <NSObject>

-(void)cashierDeskViewDeterminePaymentButtonDidClick:(YMCashierDeskView *)deskView;

-(void)cashierDeskViewSelecterBankCardButtonDidClick:(YMCashierDeskView *)deskView;

@end

@interface YMCashierDeskView : UIView

@property (nonatomic, copy) NSString *rechargeMoney;

@property (nonatomic, copy) NSString *bankInfo;

@property (nonatomic, copy) NSString *mainTitle;

@property (nonatomic, weak)id <YMCashierDeskViewdelegate> delegate;

-(void)show;
@end
