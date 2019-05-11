//
//  YMPaymentMethodView.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/16.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMPaymentMethodView,YMBankCardModel,YMPrepaidCardModel;
@protocol YMPaymentMethodViewDelegate <NSObject>

/**
 选中银行卡

 @param view YMPaymentMethodView
 @param card 银行卡模型
 */
@optional
-(void)paymentMethodView:(YMPaymentMethodView *)view withBankCard:(YMBankCardModel *)card;
/**
 选中预付卡
 
 @param view YMPaymentMethodView
 @param card 预付卡模型
 */
-(void)paymentMethodView:(YMPaymentMethodView *)view withPrepaidCard:(YMPrepaidCardModel *)card;
/**
 选中余额
 
 @param view YMPaymentMethodView
 @param card 余额
 */
-(void)paymentMethodView:(YMPaymentMethodView *)view withBalance:(NSString *)balance;

/**
 选中添加银行卡

 @param view YMPaymentMethodView
 */
-(void)paymentMethodViewWithAddBankCard:(YMPaymentMethodView *)view;

@end

@class YMBankCardModel,YMScanModel;
@interface YMPaymentMethodView : UIView

@property (nonatomic, strong) YMScanModel *scanModel;
@property (nonatomic, strong) YMBankCardModel *currentBank;

@property (nonatomic, weak) id <YMPaymentMethodViewDelegate> delegate;

-(void)show;
@end
