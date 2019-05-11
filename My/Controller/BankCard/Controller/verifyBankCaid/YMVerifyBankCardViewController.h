//
//  YMVerifyBankCardViewController.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/4/7.
//  Copyright © 2017年 赢联. All rights reserved.
//


/*
 * 验证银行卡（信息认证）界面vc
 * app4期 2017-7-21 changed by pzj
 * 信用卡时，安全码存在本地数据库。
 */
#import <UIKit/UIKit.h>
@class YMBankCardModel;
@interface YMVerifyBankCardViewController : UITableViewController

@property (nonatomic, strong) YMBankCardModel*bankCardModel;
@property (nonatomic, assign) BOOL fromXinYongCardPay;//YES 信用卡支付 NO 之前的逻辑（不传默认NO）
@property (nonatomic, strong) UIView *payCashierView;
@property (nonatomic, strong) UIView *payCardListView;
@end
