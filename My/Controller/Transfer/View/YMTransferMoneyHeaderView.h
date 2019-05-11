//
//  YMTransferMoneyHeaderView.h
//  WSYMPay
//
//  Created by pzj on 2017/5/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 有名钱包账户转账界面header View（转账金额）
 */
#import <UIKit/UIKit.h>

@class YMTransferCheckAccountDataModel;
@class YMTransferToBankSearchFeeDataModel;

@interface YMTransferMoneyHeaderView : UIView

//有名钱包账户账户转账界面headder传值
@property (nonatomic, strong)YMTransferCheckAccountDataModel *model;

//有名钱包转账到银行卡---转账确认界面header传值
@property (nonatomic, strong) YMTransferToBankSearchFeeDataModel *toBankModel;

@end
