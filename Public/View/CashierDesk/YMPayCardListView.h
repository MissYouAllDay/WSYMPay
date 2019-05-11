//
//  YMPayCardListView.h
//  WSYMPay
//
//  Created by pzj on 2017/5/23.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 新的收银台
 * 选择支付方式列表view
 */
#import <UIKit/UIKit.h>

@class YMBankCardDataModel;
@class YMBankCardModel;

@interface YMPayCardListView : UIView
#pragma mark - app4期
+(YMPayCardListView *)getPayCardListView;
/**
 调起支付方式弹框view
 
 @param vc 当前界面vc
 @param dataModel 查询的支付方式总model
 @param array 银行卡列表array
 @param payTypeModel 当前选中的model
 @param isShowBalance 是否显示余额模块
 @param resultBlock 结果回调
 */
- (void)showPayTypeViewWtihCurrentVC:(UIViewController *)vc
               withBankCardDataModel:(YMBankCardDataModel *)dataModel
                       bankCardArray:(NSMutableArray *)array
                        payTypeModel:(YMBankCardModel *)payTypeModel
                       isShowBalance:(BOOL)isShowBalance
                         resultBlock:(void(^)(YMBankCardModel *payTypeModel,NSString *payTypeStr))resultBlock;

@property (nonatomic, strong) void(^payTypeResultBlock)(YMBankCardModel *payTypeModel,NSString *payTypeStr);
@property (nonatomic, strong) void(^quitBlock)();

@property (nonatomic, strong) UIView *payCashierView;

@property (nonatomic, assign) NSInteger type;//1充值；2提现;

@end
