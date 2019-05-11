//
//  YMControlMoneyController.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/15.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMBankCardModel;
@class YMBankCardDataModel;

@interface YMControlMoneyController : UITableViewController
@property (nonatomic, strong) YMBankCardModel *currentBankCard;
@property (nonatomic, strong) NSMutableArray  *bankCardArray;
@property (nonatomic, weak)   UILabel         *balanceLabel;
@property (nonatomic, strong) YMBankCardDataModel *bankCardDataModel;//充值。。。

@property (nonatomic, weak, readonly) UITextField    *moneyTextField;
@property (nonatomic, assign) BOOL recharge; //默认是YES充值
-(void)nextBtnClick NS_REQUIRES_SUPER;
@end
