//
//  YMPayBankCarListView.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/15.
//  Copyright © 2016年 赢联. All rights reserved.
//

/*
 * 预付卡充值---银行卡、余额支付方式列表
 * changed by pzj 2017-3-21
 */
#import <UIKit/UIKit.h>


@class YMPayBankCardListView,YMBankCardModel,YMBankCardDataModel;

@protocol YMPayBankCardListViewDelegate <NSObject>

@optional
//选择银行卡后代理方法
-(void)payBankCardListViewCellDidSelected:(YMPayBankCardListView *)listView bankCardInfo:(YMBankCardModel *)m;
//选择其他后代理方法
-(void)payBankCardListViewOherCellDidSelected:(YMPayBankCardListView *)listView;
//选择取消后代理方法
-(void)payBankCardListViewQuickButtonDidClick:(YMPayBankCardListView *)listView bankCardInfo:(YMBankCardModel *)m yuE:(NSString *)yuE;
//选择余额后代理方法
-(void)payBalanceViewCellDidSelected:(YMPayBankCardListView *)listView bankCardInfo:(YMBankCardModel *)m;
@end

@interface YMPayBankCardListView : UIView
/**
 * 来自预付卡还是银行卡
 * 预付卡 传2（显示余额）
 * 银行卡 传1（不显示余额）
 * 默认 银行卡 1
 */
@property (nonatomic, assign) NSInteger fromFlag;

@property (nonatomic, strong) NSMutableArray *bankCardArray;

@property (nonatomic, strong) YMBankCardDataModel *bankCardDataModel;

- (void)sendSelectBankModel:(YMBankCardModel *)selectBankModel bankCardArray:(NSMutableArray *)bankCardArray;

@property (nonatomic, weak) id <YMPayBankCardListViewDelegate> delegate;

-(void)show;
@end
