//
//  YMPayCashierView.h
//  WSYMPay
//
//  Created by pzj on 2017/5/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 新的收银台
 */

typedef NS_ENUM(NSInteger, PayCashierType) {
    PayCashierTX                 = 1,//TX
    PayCashierMobile             = 2,//手机充值
};
#import <UIKit/UIKit.h>

@class YMBankCardDataModel;
@class YMBankCardModel;

@interface YMPayCashierView : UIView
+(YMPayCashierView *)getPayCashierView;
/**
 调起收银台View
 
 @param vc 当前界面vc
 @param model 支付方式总model
 @param money 支付金额
 @param resultBlock 结果回调
 YMBankCardModel *bankCardModel----银行卡支付时，银行卡相关的信息
 isAddCard----是否使用其他银行卡
 */
- (void)showPayCashierDeskViewWtihCurrentVC:(UIViewController *)vc
                      withBankCardDataModel:(YMBankCardDataModel *)model
                                  withMoney:(NSString *)money
                                resultBlock:(void(^)(YMBankCardModel *bankCardModel,BOOL isAddCard))resultBlock;

@property (nonatomic, strong) void(^payCashierResultBlock)(YMBankCardModel *bankCardModel,BOOL isAddCard);
@property (assign,nonatomic,readwrite) PayCashierType payCashierType;

@end
