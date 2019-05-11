//
//  YMGetUserInputCell.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/11/30.
//  Copyright © 2016年 赢联. All rights reserved.
//

/**
 我的--账户余额--收支明细--账单详情--cell
 changed by pzj-2017/3/18
 */
#import <UIKit/UIKit.h>

@class YMBillDetailKeyValueModel;
@class YMTransferToBankSearchFeeDataModel;
@class YMTransferCheckPayPwdDataModel;
@class YMBankCardModel;


@protocol YMGetUserInputCellDelegate <NSObject>

- (void)textFieldWithAnQuanMa:(NSString *)str;
- (void)textFieldWithPhone:(NSString *)str;

@end


@interface YMGetUserInputCell : UITableViewCell<YMGetUserInputCellDelegate>

@property (nonatomic, strong) UITextField * userInputTF;
@property (nonatomic, copy)   NSString *leftTitle;
@property (nonatomic, strong) YMBillDetailKeyValueModel *keyOrValueModel;
@property (nonatomic, assign) BOOL isSetWidth;//从新设置textfield的宽度
@property (nonatomic, weak) id<YMGetUserInputCellDelegate>delegate;

//转账到银行卡 信息确认cell
- (void)sendTransferWithRowNum:(NSInteger)rowNum model:(YMTransferToBankSearchFeeDataModel *)model;
//转账到银行卡 处理中。。。 cell
- (void)sendTransferProcessWithRowNum:(NSInteger)rowNum model:(YMTransferCheckPayPwdDataModel *)model;
//验证银行卡（储蓄卡、信用卡）app4期修改
- (void)sendBankCardWithSection:(NSInteger)section row:(NSInteger)row model:(YMBankCardModel *)model;

@end
